#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: leave the spare disk blank and /mnt/mbrpart unconfigured.

MNT=/mnt/mbrpart

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

# Unmount our mountpoint if a prior attempt left it mounted.
umount "$MNT" 2>/dev/null

# Remove any fstab line for our mountpoint (matched by mountpoint field).
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi

# Safely wipe the spare (guards root disk / mounted devices).
wipe_spare "$d"

systemctl daemon-reload 2>/dev/null
rmdir "$MNT" 2>/dev/null

exit 0
