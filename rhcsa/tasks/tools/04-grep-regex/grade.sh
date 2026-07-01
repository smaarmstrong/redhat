#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

expected="$(grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/access.sample)"

check_eval "/root/ips.txt exists" '[ -f /root/ips.txt ]'
check_eval "content matches every line containing an IPv4 address" \
  '[ -f /root/ips.txt ] && diff <(printf "%s\n" "$expected") /root/ips.txt'

grade_summary
