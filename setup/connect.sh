#!/usr/bin/env bash
#
# connect.sh — SSH into the running Rocky 9 practice VM.
#
# Looks up the VM's current IP from libvirt and connects with the dedicated key.
# Pass --console to attach to the serial console instead (exam-like, exit Ctrl-]).
#
set -euo pipefail

VM_NAME="${VM_NAME:-rocky9-trainer}"
GUEST_USER="${GUEST_USER:-rocky}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/redhat_rocky}"
export LIBVIRT_DEFAULT_URI="qemu:///system"

if [ "${1:-}" = "--console" ]; then
  exec sudo virsh console "$VM_NAME"
fi

ip="$(sudo virsh domifaddr "$VM_NAME" --source lease 2>/dev/null \
      | awk '/ipv4/ {print $4}' | cut -d/ -f1 | head -1)"
[ -n "$ip" ] || { echo "Couldn't find the VM's IP. Is it running? (sudo virsh list)" >&2; exit 1; }

exec ssh -i "$SSH_KEY" \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o LogLevel=ERROR \
  "${GUEST_USER}@${ip}"
