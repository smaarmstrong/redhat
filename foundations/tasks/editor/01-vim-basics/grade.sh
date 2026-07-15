#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

F=/opt/found/notes/journal.txt

check_eval "journal.txt still exists"                  '[ -f '"$F"' ]'
check_eval "the disk-usage line now says 'weekly'"     'grep -qx "Disk usage is checked weekly." '"$F"''
check_eval "MONTHLY is gone"                           '! grep -q MONTHLY '"$F"''
check_eval "last line is 'Reviewed and approved.'"     '[ "$(tail -n 1 '"$F"')" = "Reviewed and approved." ]'
check_eval "the other lines are untouched"             '[ "$(head -n 4 '"$F"')" = "$(printf "Server maintenance notes\n------------------------\nThe backup job runs at 02:00 every night.\nRemember to rotate the logs on Friday.")" ]'
check_eval "no stray extra lines (file is 6 lines)"    '[ "$(wc -l < '"$F"')" -eq 6 ]'

grade_summary
