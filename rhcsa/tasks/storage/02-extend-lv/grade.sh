#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/app

# LV size in MiB (integer).
size_mib="$(lvs --noheadings --units m --nosuffix -o lv_size vg_app/lv_app 2>/dev/null | tr -d ' ' | cut -d. -f1)"
# Filesystem size as seen by df, in MiB (1M blocks, header stripped).
fs_mib="$(df -BM --output=size "$MNT" 2>/dev/null | tail -1 | tr -dc '0-9')"

check_eval "volume group vg_app exists"          'vgs vg_app'
check_eval "logical volume lv_app exists"        'lvs vg_app/lv_app'
check_eval "lv_app extended to ~512 MiB (500-525)" '[ -n "$size_mib" ] && [ "$size_mib" -ge 500 ] && [ "$size_mib" -le 525 ]'
check_eval "/app is still mounted"               'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/app filesystem is xfs"              '[ "$(findmnt -no FSTYPE "$MNT")" = xfs ]'
check_eval "filesystem grown (df shows > 400 MiB)" '[ -n "$fs_mib" ] && [ "$fs_mib" -ge 400 ]'
check_eval "still persistent in fstab by UUID"   'findmnt --fstab -no SOURCE "$MNT" | grep -q "^UUID="'

grade_summary
