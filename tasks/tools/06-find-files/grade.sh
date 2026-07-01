#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

expected="$(find /etc -type f -name '*.conf' -size +5k 2>/dev/null | sort)"

check_eval "/root/bigconf.txt exists" '[ -f /root/bigconf.txt ]'
check_eval "content matches the sorted list of large .conf files" \
  '[ -f /root/bigconf.txt ] && diff <(printf "%s\n" "$expected") /root/bigconf.txt'

grade_summary
