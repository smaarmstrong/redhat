#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

expected="$(cut -d: -f1 /etc/passwd | sort -u)"

check_eval "/root/users.txt exists" '[ -f /root/users.txt ]'
check_eval "content is the sorted, unique list of login names" \
  '[ -f /root/users.txt ] && diff <(printf "%s\n" "$expected") /root/users.txt'

grade_summary
