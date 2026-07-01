#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
# Idempotent: leave the spare disk blank and /backup unconfigured.

MNT=/backup

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

umount "$MNT" 2>/dev/null

# Remove any fstab line for our mountpoint OR for LABEL=backup.
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
  sed -i '\%^[[:space:]]*LABEL=backup[[:space:]]%d' /etc/fstab
fi

# Safely wipe the spare (guards root disk / mounted devices).
wipe_spare "$d"

systemctl daemon-reload 2>/dev/null
rmdir "$MNT" 2>/dev/null

exit 0
