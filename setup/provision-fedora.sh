#!/usr/bin/env bash
#
# provision-fedora.sh — build the Rocky Linux 9 practice VM on a Fedora host.
#
# This is the ONE part of the project that runs on the HOST (not inside the VM),
# because the VM can't build itself. Everything else (games, tasks) runs inside
# the Rocky guest once it's up.
#
# What it does:
#   1. Preflight-checks the host (libvirt installed, running, you're in the group).
#   2. Downloads the official Rocky 9 cloud image (cached, verified by checksum).
#   3. Creates the VM disks: a root disk (overlay on the pristine image, so resets
#      are cheap later) + a blank spare disk for storage/LVM practice.
#   4. Generates a cloud-init seed (SSH key + login) and boots the VM via virt-install.
#   5. Waits for the VM's IP and prints how to connect.
#
# Re-run with --force to destroy and rebuild the VM from scratch.
#
set -euo pipefail

# ----- configuration (override via environment) -------------------------------
VM_NAME="${VM_NAME:-rocky9-trainer}"
VM_RAM="${VM_RAM:-2048}"            # MiB
VM_VCPUS="${VM_VCPUS:-2}"
ROOT_SIZE="${ROOT_SIZE:-20G}"       # root disk (auto-grows on first boot)
SPARE_SIZE="${SPARE_SIZE:-5G}"      # blank disk for storage/LVM tasks
OS_VARIANT="${OS_VARIANT:-rhel9.0}" # libosinfo profile (rocky9 often absent on older hosts)
GUEST_USER="${GUEST_USER:-rocky}"
GUEST_PASS="${GUEST_PASS:-rocky}"   # console/password login (throwaway local VM)

SSH_KEY="${SSH_KEY:-$HOME/.ssh/redhat_rocky}"   # dedicated keypair for this project
POOL="${POOL:-/var/lib/libvirt/images}"         # libvirt default storage pool
CACHE="${CACHE:-$HOME/.cache/redhat-trainer}"   # downloaded image cache (survives rebuilds)

IMG_NAME="Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
IMG_URL="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/${IMG_NAME}"
CKSUM_URL="${IMG_URL}.CHECKSUM"

export LIBVIRT_DEFAULT_URI="qemu:///system"

# ----- pretty output ----------------------------------------------------------
c_blue=$'\033[34m'; c_green=$'\033[32m'; c_yellow=$'\033[33m'; c_red=$'\033[31m'; c_off=$'\033[0m'
log()  { printf '%s==>%s %s\n' "$c_blue"   "$c_off" "$*"; }
ok()   { printf '%s ok%s %s\n' "$c_green"  "$c_off" "$*"; }
warn() { printf '%swarn%s %s\n' "$c_yellow" "$c_off" "$*"; }
die()  { printf '%serror%s %s\n' "$c_red"   "$c_off" "$*" >&2; exit 1; }

FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown argument: $arg (try --help)" ;;
  esac
done

# ----- 1. preflight ------------------------------------------------------------
preflight() {
  log "Preflight: checking the host"
  local problems=0

  if ! command -v virt-install >/dev/null; then
    warn "virt-install is not installed"
    problems=1
  fi
  if ! command -v qemu-img >/dev/null; then
    warn "qemu-img is not installed"
    problems=1
  fi
  if ! systemctl is-active --quiet libvirtd 2>/dev/null \
     && ! systemctl is-active --quiet virtqemud 2>/dev/null; then
    warn "the libvirt daemon is not running"
    problems=1
  fi
  if ! id -nG | tr ' ' '\n' | grep -qx libvirt; then
    warn "you are not in the 'libvirt' group (you'll be prompted for sudo a lot)"
    problems=1
  fi

  if [ "$problems" -ne 0 ]; then
    cat <<EOF

${c_yellow}One-time host setup needed.${c_off} Run these once, then re-run this script:

  ${c_green}sudo dnf install -y virt-install libvirt qemu-kvm genisoimage${c_off}
  ${c_green}sudo systemctl enable --now libvirtd${c_off}
  ${c_green}sudo usermod -aG libvirt "\$USER"${c_off}

Then log out and back in (or run \`newgrp libvirt\`) so the group takes effect.
EOF
    die "host not ready"
  fi
  ok "host looks ready"
}

# ----- 2. ssh key --------------------------------------------------------------
ensure_ssh_key() {
  if [ ! -f "$SSH_KEY" ]; then
    log "Creating a dedicated SSH key for the trainer ($SSH_KEY)"
    ssh-keygen -t ed25519 -N "" -f "$SSH_KEY" -C "redhat-trainer" >/dev/null
    ok "generated $SSH_KEY"
  else
    ok "using existing key $SSH_KEY"
  fi
}

# ----- 3. download + verify base image ----------------------------------------
fetch_image() {
  mkdir -p "$CACHE"
  local img="$CACHE/$IMG_NAME"
  if [ ! -f "$img" ]; then
    log "Downloading Rocky 9 cloud image (~600 MB, one time)"
    curl -fL --progress-bar -o "$img" "$IMG_URL" || die "download failed"
  else
    ok "cloud image already cached"
  fi

  log "Verifying checksum"
  local expected
  expected="$(curl -fsSL "$CKSUM_URL" 2>/dev/null \
              | awk -v f="$IMG_NAME" '$0 ~ "SHA256.*" f')" || true
  expected="${expected##*= }"
  if [ -n "$expected" ]; then
    local actual; actual="$(sha256sum "$img" | awk '{print $1}')"
    if [ "$actual" != "$expected" ]; then
      die "checksum mismatch — delete $img and re-run"
    fi
    ok "checksum verified"
  else
    warn "could not fetch checksum; skipping verification"
  fi
  CACHED_IMG="$img"
}

# ----- 4. (re)build VM disks ---------------------------------------------------
maybe_destroy_existing() {
  if virsh dominfo "$VM_NAME" >/dev/null 2>&1; then
    if [ "$FORCE" -eq 1 ]; then
      log "Destroying existing VM '$VM_NAME' (--force)"
      virsh destroy "$VM_NAME" >/dev/null 2>&1 || true
      virsh undefine "$VM_NAME" --nvram --remove-all-storage >/dev/null 2>&1 \
        || virsh undefine "$VM_NAME" >/dev/null 2>&1 || true
      ok "removed old VM"
    else
      die "VM '$VM_NAME' already exists. Connect with setup/connect.sh, or pass --force to rebuild."
    fi
  fi
}

build_disks() {
  local base="$POOL/${VM_NAME}-base.qcow2"
  local root="$POOL/${VM_NAME}.qcow2"
  local spare="$POOL/${VM_NAME}-spare.qcow2"

  log "Placing pristine base image into the libvirt pool"
  sudo cp -n "$CACHED_IMG" "$base"

  log "Creating root disk as an overlay on the base (cheap to reset later)"
  sudo rm -f "$root"
  sudo qemu-img create -q -f qcow2 -F qcow2 -b "$base" "$root" "$ROOT_SIZE"

  log "Creating blank spare disk for storage/LVM practice ($SPARE_SIZE)"
  sudo rm -f "$spare"
  sudo qemu-img create -q -f qcow2 "$spare" "$SPARE_SIZE"

  # Make sure SELinux labels let qemu read the whole backing chain.
  sudo restorecon -R "$POOL" >/dev/null 2>&1 || true

  ROOT_DISK="$root"; SPARE_DISK="$spare"
}

# ----- 5. cloud-init seed ------------------------------------------------------
build_seed() {
  local seed="$POOL/${VM_NAME}-seed.iso"
  local tmp; tmp="$(mktemp -d)"
  local pubkey; pubkey="$(cat "${SSH_KEY}.pub")"

  cat > "$tmp/meta-data" <<EOF
instance-id: ${VM_NAME}
local-hostname: ${VM_NAME}
EOF

  cat > "$tmp/user-data" <<EOF
#cloud-config
hostname: ${VM_NAME}
ssh_pwauth: true
users:
  - name: ${GUEST_USER}
    groups: [wheel]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: /bin/bash
    lock_passwd: false
    ssh_authorized_keys:
      - ${pubkey}
chpasswd:
  expire: false
  list: |
    ${GUEST_USER}:${GUEST_PASS}
EOF

  log "Building cloud-init seed image"
  genisoimage -quiet -output "$tmp/seed.iso" -volid cidata -joliet -rock \
    "$tmp/user-data" "$tmp/meta-data"
  sudo cp "$tmp/seed.iso" "$seed"
  sudo restorecon "$seed" >/dev/null 2>&1 || true
  rm -rf "$tmp"
  SEED_ISO="$seed"
}

# ----- 6. boot the VM ----------------------------------------------------------
boot_vm() {
  log "Creating and booting the VM with virt-install"
  sudo virt-install \
    --connect "$LIBVIRT_DEFAULT_URI" \
    --name "$VM_NAME" \
    --memory "$VM_RAM" \
    --vcpus "$VM_VCPUS" \
    --os-variant "$OS_VARIANT" \
    --import \
    --disk "path=${ROOT_DISK},format=qcow2,bus=virtio" \
    --disk "path=${SPARE_DISK},format=qcow2,bus=virtio" \
    --disk "path=${SEED_ISO},device=cdrom" \
    --network network=default,model=virtio \
    --graphics none \
    --console pty,target_type=serial \
    --noautoconsole
  ok "VM defined and starting"
}

wait_for_ip() {
  log "Waiting for the VM to get an IP (cloud-init runs on first boot, ~30-60s)"
  local ip="" tries=0
  while [ -z "$ip" ] && [ "$tries" -lt 60 ]; do
    ip="$(sudo virsh domifaddr "$VM_NAME" --source lease 2>/dev/null \
          | awk '/ipv4/ {print $4}' | cut -d/ -f1 | head -1)"
    [ -n "$ip" ] && break
    sleep 3; tries=$((tries+1)); printf '.'
  done
  printf '\n'
  [ -n "$ip" ] || die "timed out waiting for an IP. Check: sudo virsh console $VM_NAME"
  VM_IP="$ip"
  ok "VM is up at $VM_IP"
}

# ----- run ---------------------------------------------------------------------
preflight
ensure_ssh_key
fetch_image
maybe_destroy_existing
build_disks
build_seed
boot_vm
wait_for_ip

cat <<EOF

${c_green}Rocky 9 practice VM is ready!${c_off}

  SSH in:        ssh -i ${SSH_KEY} ${GUEST_USER}@${VM_IP}
  Or use:        setup/connect.sh
  Serial console: sudo virsh console ${VM_NAME}   (exit with Ctrl-])
  Login:         ${GUEST_USER} / ${GUEST_PASS}

Inside the VM, clone this repo and start a game:
  git clone <this-repo-url> ~/redhat && cd ~/redhat

Rebuild from scratch any time:  $0 --force
EOF
