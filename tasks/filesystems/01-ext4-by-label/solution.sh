#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
set -e

MNT=/backup
d="$(spare_disk)"

# GPT label + one partition spanning the disk.
parted -s "$d" mklabel gpt
parted -s "$d" mkpart primary ext4 1MiB 100%
partprobe "$d"
sleep 1

# First partition device (handles /dev/vdb1 and /dev/nvme0n1p1 style names).
part="$(lsblk -rno NAME "$d" | sed -n 2p)"
part="/dev/$part"

mkfs.ext4 -F -L backup "$part"

mkdir -p "$MNT"
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'LABEL=backup  %s  ext4  defaults  0 0\n' "$MNT" >> /etc/fstab

systemctl daemon-reload
mount -a
