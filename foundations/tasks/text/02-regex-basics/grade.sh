#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

R=/opt/found/regexlab

check_eval "inventory.txt still intact"                '[ "$(wc -l < $R/inventory.txt)" -eq 10 ]'
check_eval "codes.txt: the 3 lines with XX-9999 codes" '[ -f $R/codes.txt ] && [ "$(cat $R/codes.txt)" = "$(grep -E "[A-Z]{2}-[0-9]{4}" $R/inventory.txt)" ]'
check_eval "codes.txt excludes the CD-77 near-miss"    '[ -f $R/codes.txt ] && ! grep -q "CD-77" $R/codes.txt'
check_eval "comments.txt: the 2 lines starting with #" '[ -f $R/comments.txt ] && [ "$(cat $R/comments.txt)" = "$(grep "^#" $R/inventory.txt)" ]'
check_eval "prices.txt: the 5 lines ending in a price" '[ -f $R/prices.txt ] && [ "$(cat $R/prices.txt)" = "$(grep -E "[0-9]+\.[0-9]{2}\$" $R/inventory.txt)" ]'

grade_summary
