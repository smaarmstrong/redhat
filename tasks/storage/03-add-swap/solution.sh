#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
set -e

d="$(spare_disk)"

# GPT label + a 256 MiB partition, tagged as Linux swap type.
parted -s "$d" mklabel gpt
parted -s "$d" mkpart primary linux-swap 1MiB 257MiB
partprobe "$d"
sleep 1

# First partition device (handles vdb1 / nvme0n1p1 naming).
part="$(lsblk -rno NAME "$d" | sed -n 2p)"
part="/dev/$part"

mkswap "$part"
swapon "$part"

uuid="$(blkid -s UUID -o value "$part")"
# Remove any stale line for this UUID, then append a persistent one.
sed -i "\%UUID=$uuid%d" /etc/fstab
printf 'UUID=%s  none  swap  defaults  0 0\n' "$uuid" >> /etc/fstab

systemctl daemon-reload
swapon -a
