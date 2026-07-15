#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

B=/opt/found/findlab
logs="$(printf '%s\n' "$B/reports/feb.log" "$B/reports/jan.log" "$B/src/app.log")"

check_eval "logfiles.txt lists the 3 .log paths, sorted" '[ -f $B/logfiles.txt ] && [ "$(sort $B/logfiles.txt)" = "$logs" ]'
check_eval "every .tmp file is gone"                     '[ -z "$(find $B -name "*.tmp" -not -path "$B/big/*" 2>/dev/null)" ]'
check_eval "non-tmp files survived the delete"           '[ -f $B/reports/notes.txt ] && [ -f $B/src/app.py ] && [ -f $B/data/small.bin ]'
check_eval "big/ contains a copy of big.bin"             '[ -f $B/big/big.bin ]'
check_eval "the copy is the full file (>1 MiB)"          '[ "$(stat -c %s $B/big/big.bin)" -gt 1048576 ]'
check_eval "the original big.bin stayed in place"        '[ -f $B/data/big.bin ]'

grade_summary
