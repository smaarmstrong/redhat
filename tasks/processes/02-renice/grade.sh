#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

pid=$(pgrep -f nicejob | head -1)

check_eval "the nicejob process is still running" '[ -n "$pid" ]'
check_eval "its nice value is 10" \
  '[ -n "$pid" ] && [ "$(ps -o ni= -p "$pid" 2>/dev/null | tr -d " ")" = "10" ]'

grade_summary
