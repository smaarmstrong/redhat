#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
# ansible.posix.mount ships in the ansible.posix collection; install best-effort.
command -v ansible-galaxy >/dev/null && ansible-galaxy collection install ansible.posix >/dev/null 2>&1 || true
# Undo target end state: unmount and strip any prior fstab entry for /mnt/ramdisk.
umount /mnt/ramdisk 2>/dev/null || true
if [ -f /etc/fstab ]; then
  sed -i '\#[[:space:]]/mnt/ramdisk[[:space:]]#d' /etc/fstab 2>/dev/null || true
fi
d=/opt/rhce/mount
mkdir -p "$d"; rm -f "$d/playbook.yml"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
