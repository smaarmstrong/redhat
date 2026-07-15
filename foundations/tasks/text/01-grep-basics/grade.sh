#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

L=/opt/found/loglab

check_eval "app.log still intact"                       '[ "$(wc -l < $L/app.log)" -eq 12 ]'
check_eval "errors.txt: the 3 error lines, any case"    '[ -f $L/errors.txt ] && [ "$(cat $L/errors.txt)" = "$(grep -i error $L/app.log)" ]'
check_eval "warnings.txt: the 3 warning lines, any case" '[ -f $L/warnings.txt ] && [ "$(cat $L/warnings.txt)" = "$(grep -i warning $L/app.log)" ]'
check_eval "nodebug.txt: every line without DEBUG"       '[ -f $L/nodebug.txt ] && [ "$(cat $L/nodebug.txt)" = "$(grep -v DEBUG $L/app.log)" ]'

grade_summary
