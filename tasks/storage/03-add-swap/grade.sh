#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

d="$(spare_disk)"

# Find a swap-formatted partition on the spare disk.
part=
for p in "$d"[0-9]*; do
  [ -b "$p" ] || continue
  if [ "$(blkid -s TYPE -o value "$p" 2>/dev/null)" = swap ]; then
    part="$p"; break
  fi
done

uuid="$(blkid -s UUID -o value "$part" 2>/dev/null)"
# Partition size in MiB (bytes / 1048576).
bytes="$(lsblk -bn -o SIZE "$part" 2>/dev/null | head -1)"
size_mib=$(( ${bytes:-0} / 1048576 ))

check_eval "a swap partition exists on the spare disk" '[ -n "$part" ] && [ -b "$part" ]'
check_eval "partition is ~256 MiB (240-272)"           '[ "$size_mib" -ge 240 ] && [ "$size_mib" -le 272 ]'
check_eval "partition TYPE is swap"                    '[ "$(blkid -s TYPE -o value "$part")" = swap ]'
check_eval "swap is active (in /proc/swaps)"           '[ -n "$part" ] && grep -q "^$(readlink -f "$part") " /proc/swaps'
check_eval "fstab has this swap by UUID"               '[ -n "$uuid" ] && grep -Ei "^[[:space:]]*UUID=$uuid[[:space:]]" /etc/fstab | grep -qw swap'
check_eval "fstab entry fstype is swap"                '[ -n "$uuid" ] && [ "$(grep -Ei "^[[:space:]]*UUID=$uuid[[:space:]]" /etc/fstab | awk "{print \$3}")" = swap ]'

grade_summary
