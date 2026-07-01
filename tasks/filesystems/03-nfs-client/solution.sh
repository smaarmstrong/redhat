#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
set -e

MNT=/mnt/nfs
EXPORT=localhost:/srv/share

mkdir -p "$MNT"

# Persistent NFS entry, then mount it.
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf '%s  %s  nfs  _netdev  0 0\n' "$EXPORT" "$MNT" >> /etc/fstab

systemctl daemon-reload
mount "$MNT"
