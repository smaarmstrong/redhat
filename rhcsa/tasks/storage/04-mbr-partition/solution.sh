#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/mnt/mbrpart
d="$(spare_disk)"

# MBR (msdos) label + one primary partition of ~300 MiB.
parted -s "$d" mklabel msdos
parted -s "$d" mkpart primary ext4 1MiB 301MiB
partprobe "$d"
sleep 1

# First partition device (handles vdb1 / nvme0n1p1 naming).
part="$(lsblk -rno NAME "$d" | sed -n 2p)"
part="/dev/$part"

mkfs.ext4 -F "$part"

mkdir -p "$MNT"
uuid="$(blkid -s UUID -o value "$part")"

sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'UUID=%s  %s  ext4  defaults  0 0\n' "$uuid" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount -a
