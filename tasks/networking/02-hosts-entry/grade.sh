#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "db.example.com resolves to 192.168.55.10" \
  '[ "$(getent hosts db.example.com | awk "{print \$1}")" = "192.168.55.10" ]'
check_eval "short alias db resolves to 192.168.55.10" \
  '[ "$(getent hosts db | awk "{print \$1}")" = "192.168.55.10" ]'
check_eval "/etc/hosts has the mapping line" \
  'grep -Eq "^[[:space:]]*192\.168\.55\.10[[:space:]]+.*\bdb\.example\.com\b" /etc/hosts'

grade_summary
