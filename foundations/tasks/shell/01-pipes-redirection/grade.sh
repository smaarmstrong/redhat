#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

S=/opt/found/shop

check_eval "orders.txt still intact"          '[ "$(wc -l < $S/orders.txt)" -eq 7 ]'
check_eval "sorted.txt is orders.txt, sorted" '[ -f $S/sorted.txt ] && [ "$(cat $S/sorted.txt)" = "$(sort $S/orders.txt)" ]'
check_eval "unique.txt: each product once, sorted" '[ -f $S/unique.txt ] && [ "$(cat $S/unique.txt)" = "$(sort -u $S/orders.txt)" ]'
check_eval "count.txt holds the line count (7)"    '[ -f $S/count.txt ] && [ "$(awk "{print \$1; exit}" $S/count.txt)" = "7" ]'
check_eval "errors.txt captured the ls error"      '[ -s $S/errors.txt ] && grep -qi "no such file" $S/errors.txt'

grade_summary
