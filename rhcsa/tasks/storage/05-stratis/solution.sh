#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/mnt/stratis
d="$(spare_disk)"

# stratisd must be running for the CLI to work.
systemctl enable --now stratisd

stratis pool create pool1 "$d"
stratis filesystem create pool1 fs1

mkdir -p "$MNT"

# Reference by UUID; the x-systemd.requires option makes systemd wait for
# stratisd before attempting the mount at boot.
uuid="$(blkid -s UUID -o value /dev/stratis/pool1/fs1)"

sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'UUID=%s  %s  xfs  defaults,x-systemd.requires=stratisd.service  0 0\n' \
  "$uuid" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount "$MNT"
