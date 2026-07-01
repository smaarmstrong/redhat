#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
set -e

MNT=/mnt/vfat
d="$(spare_disk)"

# GPT label + a ~200 MiB partition.
parted -s "$d" mklabel gpt
parted -s "$d" mkpart primary fat32 1MiB 201MiB
partprobe "$d"
sleep 1

# First partition device (handles vdb1 / nvme0n1p1 naming).
part="$(lsblk -rno NAME "$d" | sed -n 2p)"
part="/dev/$part"

mkfs.vfat "$part"

mkdir -p "$MNT"
uuid="$(blkid -s UUID -o value "$part")"

sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'UUID=%s  %s  vfat  defaults  0 0\n' "$uuid" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount -a
