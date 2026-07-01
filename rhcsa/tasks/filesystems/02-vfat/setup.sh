#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: leave the spare disk blank and /mnt/vfat unconfigured.
# Best-effort install of dosfstools (provides mkfs.vfat) — no internet assumed.

MNT=/mnt/vfat

# Ensure mkfs.vfat is available if a local repo can supply it.
command -v mkfs.vfat >/dev/null 2>&1 || dnf -y install dosfstools 2>/dev/null || true

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

umount "$MNT" 2>/dev/null

if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi

wipe_spare "$d"

systemctl daemon-reload 2>/dev/null
rmdir "$MNT" 2>/dev/null

exit 0
