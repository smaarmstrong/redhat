#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

A=/opt/found/awklab
names="$(printf 'alice\nbob\ncarol\ndave\nerin\nfrank')"
locs="$(printf 'alice London\nbob Leeds\ncarol Bristol\ndave London\nerin Bristol\nfrank Leeds')"
eng="$(printf 'alice:Engineering:London:1200\ncarol:Engineering:Bristol:1400\nfrank:Engineering:Leeds:700')"

check_eval "staff.txt still intact"                     '[ "$(wc -l < $A/staff.txt)" -eq 6 ]'
check_eval "names.txt: every username, in order"        '[ -f $A/names.txt ] && [ "$(cat $A/names.txt)" = "$names" ]'
check_eval "locations.txt: 'username city' per record"  '[ -f $A/locations.txt ] && [ "$(cat $A/locations.txt)" = "$locs" ]'
check_eval "engineering.txt: full Engineering records"  '[ -f $A/engineering.txt ] && [ "$(cat $A/engineering.txt)" = "$eng" ]'

grade_summary
