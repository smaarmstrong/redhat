#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/data
d="$(spare_disk)"

pvcreate -y "$d"
vgcreate vg_data "$d"
lvcreate -y -L 512M -n lv_files vg_data
mkfs.xfs -f /dev/vg_data/lv_files

mkdir -p "$MNT"
uuid="$(blkid -s UUID -o value /dev/vg_data/lv_files)"

# Append a persistent, UUID-referenced fstab entry (idempotent).
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'UUID=%s  %s  xfs  defaults  0 0\n' "$uuid" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount -a
