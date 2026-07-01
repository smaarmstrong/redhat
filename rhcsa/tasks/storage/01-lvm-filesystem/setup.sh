#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent setup: leave the spare disk blank and /data unconfigured.

MNT=/data

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

# Unmount /data if something is mounted there from a prior attempt.
umount "$MNT" 2>/dev/null

# Tear down our VG if it exists (in case it lives on the spare).
if vgs vg_data >/dev/null 2>&1; then
  swapoff /dev/vg_data/* 2>/dev/null
  vgchange -an vg_data >/dev/null 2>&1
  vgremove -f vg_data >/dev/null 2>&1
fi

# Remove any fstab line for our mountpoint.
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi

# Safely wipe the spare (guards against root disk / mounted devices).
wipe_spare "$d"

# Reload systemd so a stale fstab mount unit does not linger.
systemctl daemon-reload 2>/dev/null

rmdir "$MNT" 2>/dev/null

exit 0
