#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/mnt/nfs
EXPORT=localhost:/srv/share

mkdir -p "$MNT"

# Persistent NFS entry, then mount it.
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf '%s  %s  nfs  _netdev  0 0\n' "$EXPORT" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount "$MNT"
