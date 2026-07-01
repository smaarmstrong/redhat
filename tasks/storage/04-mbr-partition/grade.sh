#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

MNT=/mnt/mbrpart
d="$(spare_disk)"

# The partition table type on the spare disk (dos = MBR/MS-DOS).
pttype="$(blkid -s PTTYPE -o value "$d" 2>/dev/null)"

# Find the first ext4 partition on the spare disk.
part=
for p in "$d"[0-9]*; do
  [ -b "$p" ] || continue
  if [ "$(blkid -s TYPE -o value "$p" 2>/dev/null)" = ext4 ]; then
    part="$p"; break
  fi
done

uuid="$(blkid -s UUID -o value "$part" 2>/dev/null)"
# Partition size in MiB (bytes / 1048576).
bytes="$(lsblk -bn -o SIZE "$part" 2>/dev/null | head -1)"
size_mib=$(( ${bytes:-0} / 1048576 ))

check_eval "spare disk has an MBR (msdos) partition table" '[ "$pttype" = dos ]'
check_eval "an ext4 partition exists on the spare disk"    '[ -n "$part" ] && [ -b "$part" ]'
check_eval "partition is ~300 MiB (285-315)"               '[ "$size_mib" -ge 285 ] && [ "$size_mib" -le 315 ]'
check_eval "filesystem type is ext4"                       '[ "$(findmnt -no FSTYPE "$MNT")" = ext4 ]'
check_eval "mounted at /mnt/mbrpart"                       'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/mnt/mbrpart backed by that partition"         '[ -n "$part" ] && [ "$(readlink -f "$(findmnt -no SOURCE "$MNT")")" = "$(readlink -f "$part")" ]'
check_eval "fstab entry for /mnt/mbrpart by UUID"          'findmnt --fstab -no SOURCE "$MNT" | grep -q "^UUID="'
check_eval "fstab UUID matches the partition"              '[ -n "$uuid" ] && findmnt --fstab -no SOURCE "$MNT" | grep -qi "^UUID=$uuid$"'

grade_summary
