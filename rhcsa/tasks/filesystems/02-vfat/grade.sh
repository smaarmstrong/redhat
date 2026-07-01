#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/mnt/vfat
d="$(spare_disk)"

# If dosfstools is absent, mkfs.vfat could never have run — say so, but still
# grade the end state honestly (the vfat checks will fail rather than pass).
if ! command -v mkfs.vfat >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} mkfs.vfat not found — install the dosfstools package (dnf install dosfstools)\n"
fi

# Find the first vfat partition on the spare disk.
part=
for p in "$d"[0-9]*; do
  [ -b "$p" ] || continue
  if [ "$(blkid -s TYPE -o value "$p" 2>/dev/null)" = vfat ]; then
    part="$p"; break
  fi
done

uuid="$(blkid -s UUID -o value "$part" 2>/dev/null)"
bytes="$(lsblk -bn -o SIZE "$part" 2>/dev/null | head -1)"
size_mib=$(( ${bytes:-0} / 1048576 ))

check_eval "a vfat partition exists on the spare disk" '[ -n "$part" ] && [ -b "$part" ]'
check_eval "partition is ~200 MiB (185-215)"           '[ "$size_mib" -ge 185 ] && [ "$size_mib" -le 215 ]'
check_eval "filesystem type is vfat"                   '[ "$(findmnt -no FSTYPE "$MNT")" = vfat ]'
check_eval "mounted at /mnt/vfat"                      'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/mnt/vfat backed by that partition"        '[ -n "$part" ] && [ "$(readlink -f "$(findmnt -no SOURCE "$MNT")")" = "$(readlink -f "$part")" ]'
check_eval "fstab entry for /mnt/vfat by UUID"         'findmnt --fstab -no SOURCE "$MNT" | grep -q "^UUID="'
check_eval "fstab UUID matches the filesystem"         '[ -n "$uuid" ] && findmnt --fstab -no SOURCE "$MNT" | grep -qi "^UUID=$uuid$"'

grade_summary
