#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

pid=$(pgrep -f nicejob | head -1)

check_eval "the nicejob process is still running" '[ -n "$pid" ]'
check_eval "its nice value is 10" \
  '[ -n "$pid" ] && [ "$(ps -o ni= -p "$pid" 2>/dev/null | tr -d " ")" = "10" ]'

grade_summary
