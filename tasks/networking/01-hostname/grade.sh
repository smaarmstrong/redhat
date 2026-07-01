#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "static hostname is server1.example.com" \
  '[ "$(hostnamectl --static 2>/dev/null)" = "server1.example.com" ]'
check_eval "/etc/hostname contains server1.example.com" \
  'grep -qx "server1.example.com" /etc/hostname'

grade_summary
