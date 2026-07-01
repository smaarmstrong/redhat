#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/backup
d="$(spare_disk)"

# Find an ext4 partition labelled 'backup' on the spare disk.
part=
for p in "$d"[0-9]*; do
  [ -b "$p" ] || continue
  if [ "$(blkid -s TYPE -o value "$p" 2>/dev/null)" = ext4 ] && \
     [ "$(blkid -s LABEL -o value "$p" 2>/dev/null)" = backup ]; then
    part="$p"; break
  fi
done

check_eval "ext4 partition labelled 'backup' on spare disk" '[ -n "$part" ] && [ -b "$part" ]'
check_eval "filesystem type is ext4"        '[ "$(findmnt -no FSTYPE "$MNT")" = ext4 ]'
check_eval "filesystem label is 'backup'"   '[ "$(blkid -s LABEL -o value "$part")" = backup ]'
check_eval "mounted at /backup"             'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/backup backed by the labelled partition" '[ "$(readlink -f "$(findmnt -no SOURCE "$MNT")")" = "$(readlink -f "$part")" ]'
check_eval "fstab source is LABEL=backup"   'findmnt --fstab -no SOURCE "$MNT" | grep -qx "LABEL=backup"'

grade_summary
