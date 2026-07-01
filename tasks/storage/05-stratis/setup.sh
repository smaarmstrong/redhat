#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
# Idempotent: best-effort install stratis, start stratisd, and tear down any
# prior pool1 so the spare disk starts blank and /mnt/stratis unconfigured.

MNT=/mnt/stratis

# Best-effort install (no internet assumed).
command -v stratis >/dev/null 2>&1 || dnf -y install stratisd stratis-cli 2>/dev/null || true
systemctl enable --now stratisd 2>/dev/null || true

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

# Unmount our mountpoint from a prior attempt.
umount "$MNT" 2>/dev/null

# Remove any fstab line for our mountpoint.
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi

# Tear down a prior pool1 (filesystem first, then the pool) if stratis is up.
if command -v stratis >/dev/null 2>&1; then
  stratis filesystem destroy pool1 fs1 2>/dev/null || true
  stratis pool destroy pool1 2>/dev/null || true
fi

systemctl daemon-reload 2>/dev/null

# Safely wipe the spare (guards root disk / mounted devices; clears any
# leftover Stratis signatures).
wipe_spare "$d"

rmdir "$MNT" 2>/dev/null

exit 0
