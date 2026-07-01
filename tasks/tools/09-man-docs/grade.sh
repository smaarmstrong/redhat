#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

# apropos is provided by man-db. Without it the task can't be graded.
if ! command -v apropos >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} 'apropos' (man-db) is not installed — cannot grade this task.\n"
  grade_summary
  exit $?
fi

expected="$(apropos password 2>/dev/null)"

# Guard: if the man-db cache is empty apropos returns nothing; grading would
# be meaningless. Rebuild once, best-effort, then re-check.
if [ -z "$expected" ]; then
  mandb -q >/dev/null 2>&1
  expected="$(apropos password 2>/dev/null)"
fi

if [ -z "$expected" ]; then
  printf "  ${C_Y}note${C_0} 'apropos password' returned nothing — the man-db keyword index is not built on this system.\n"
  grade_summary
  exit $?
fi

check_eval "/root/pw-cmds.txt exists" '[ -f /root/pw-cmds.txt ]'
check_eval "content matches 'apropos password' output" \
  '[ -f /root/pw-cmds.txt ] && [ "$(cat /root/pw-cmds.txt)" = "$expected" ]'

grade_summary
