#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: build vg_app + a 256 MiB lv_app (xfs) mounted at /app by UUID,
# so the user has an existing LV to extend.

MNT=/app

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

# Tear down any prior state cleanly.
umount "$MNT" 2>/dev/null
if vgs vg_app >/dev/null 2>&1; then
  vgchange -an vg_app >/dev/null 2>&1
  vgremove -f vg_app >/dev/null 2>&1
fi
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
wipe_spare "$d"
systemctl daemon-reload 2>/dev/null

# Rebuild the starting state: 256 MiB LV, XFS, mounted at /app by UUID.
pvcreate -y "$d" >/dev/null
vgcreate vg_app "$d" >/dev/null
lvcreate -y -L 256M -n lv_app vg_app >/dev/null
mkfs.xfs -f /dev/vg_app/lv_app >/dev/null 2>&1

mkdir -p "$MNT"
uuid="$(blkid -s UUID -o value /dev/vg_app/lv_app)"
printf 'UUID=%s  %s  xfs  defaults  0 0\n' "$uuid" "$MNT" >> /etc/fstab
systemctl daemon-reload 2>/dev/null
mount "$MNT"

exit 0
