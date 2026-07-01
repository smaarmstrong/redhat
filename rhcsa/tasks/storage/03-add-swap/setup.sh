#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: leave the spare disk blank; do NOT disturb the system's base swap.

d="$(spare_disk)" || { echo "no spare disk found"; exit 0; }

# BEFORE wiping, collect UUIDs of any partitions on the spare so we can
# remove exactly their fstab lines (and only theirs — never the base swap).
part=
for part in "$d"[0-9]*; do
  [ -b "$part" ] || continue
  # Turn off swap only on the spare's own partitions.
  swapoff "$part" 2>/dev/null
  u="$(blkid -s UUID -o value "$part" 2>/dev/null)"
  if [ -n "$u" ] && [ -f /etc/fstab ]; then
    sed -i "\%UUID=$u%d" /etc/fstab
  fi
done

# Safely wipe the spare (guards root disk / mounted devices; also swapoff's
# the spare's partitions).
wipe_spare "$d"

systemctl daemon-reload 2>/dev/null

exit 0
