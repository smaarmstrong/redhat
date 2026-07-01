#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/data
LV=/dev/vg_data/lv_files

# Resolve the LV device and its size in MiB (best effort; used in evals).
lvpath="$(lvs --noheadings -o lv_path vg_data/lv_files 2>/dev/null | tr -d ' ')"
size_mib="$(lvs --noheadings --units m --nosuffix -o lv_size vg_data/lv_files 2>/dev/null | tr -d ' ' | cut -d. -f1)"
uuid="$(findmnt -no UUID "$MNT" 2>/dev/null)"

check_eval "volume group vg_data exists"        'vgs vg_data'
check_eval "logical volume lv_files exists"     'lvs vg_data/lv_files'
check_eval "lv_files size is ~512 MiB (500-525)" '[ -n "$size_mib" ] && [ "$size_mib" -ge 500 ] && [ "$size_mib" -le 525 ]'
check_eval "filesystem on lv_files is xfs"      '[ "$(blkid -s TYPE -o value "$lvpath")" = xfs ]'
check_eval "mounted at /data"                   'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/data is backed by lv_files"        '[ "$(readlink -f "$(findmnt -no SOURCE "$MNT")")" = "$(readlink -f "$LV")" ]'
check_eval "fstab entry for /data by UUID"      'findmnt --fstab -no SOURCE "$MNT" | grep -q "^UUID="'
check_eval "fstab UUID matches mounted fs"      '[ -n "$uuid" ] && findmnt --fstab -no SOURCE "$MNT" | grep -qi "^UUID=$uuid$"'

grade_summary
