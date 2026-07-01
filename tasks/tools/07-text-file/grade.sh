#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

expected="$(printf 'Authorized access only.\nContact ops@example.com\n')"

check_eval "/etc/motd exists" '[ -f /etc/motd ]'
check_eval "content is exactly the two required lines" \
  '[ -f /etc/motd ] && diff <(printf "%s" "$expected") /etc/motd'

grade_summary
