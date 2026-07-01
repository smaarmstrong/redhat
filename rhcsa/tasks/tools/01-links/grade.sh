#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "/opt/src/original.txt exists"        '[ -f /opt/src/original.txt ]'
check_eval "hardlink.txt exists"                 '[ -e /opt/src/hardlink.txt ]'
check_eval "hardlink.txt shares original's inode" '[ /opt/src/hardlink.txt -ef /opt/src/original.txt ]'
check_eval "hardlink.txt is not itself a symlink" '[ ! -L /opt/src/hardlink.txt ]'
check_eval "symlink.txt is a symbolic link"      '[ -L /opt/src/symlink.txt ]'
check_eval "symlink.txt points to original.txt"  '[ "$(readlink /opt/src/symlink.txt 2>/dev/null | xargs -r basename)" = original.txt ]'
check_eval "symlink.txt resolves to the file"    '[ /opt/src/symlink.txt -ef /opt/src/original.txt ]'

grade_summary
