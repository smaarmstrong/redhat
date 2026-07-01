#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

F=/home/operator/created-by-me.txt

check_eval "file $F exists"           '[ -f "$F" ]'
check_eval "file is owned by operator" '[ -f "$F" ] && [ "$(stat -c %U "$F")" = "operator" ]'
check_eval "file is in operator's home" '[ -f "$F" ] && [ "$(dirname "$F")" = "$(getent passwd operator | cut -d: -f6)" ]'

grade_summary
