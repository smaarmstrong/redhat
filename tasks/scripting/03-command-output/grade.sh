#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

SCRIPT=/usr/local/bin/countusers.sh
expected="$(getent passwd | wc -l)"

check_eval "$SCRIPT exists"     '[ -f "$SCRIPT" ]'
check_eval "$SCRIPT is executable" '[ -x "$SCRIPT" ]'
check_eval "script output equals the number of user accounts ($expected)" \
  '[ -x "$SCRIPT" ] && [ "$(bash "$SCRIPT" 2>/dev/null | tr -d "[:space:]")" = "$expected" ]'

grade_summary
