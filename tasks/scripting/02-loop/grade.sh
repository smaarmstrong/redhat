#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

SCRIPT=/usr/local/bin/sumargs.sh

check_eval "$SCRIPT exists" \
  '[ -f "$SCRIPT" ]'
check_eval "$SCRIPT is executable" \
  '[ -x "$SCRIPT" ]'
check_eval "sumargs.sh 2 3 5 prints 10" \
  '[ "$(bash "$SCRIPT" 2 3 5 2>/dev/null)" = "10" ]'
check_eval "sumargs.sh 4 prints 4" \
  '[ "$(bash "$SCRIPT" 4 2>/dev/null)" = "4" ]'

grade_summary
