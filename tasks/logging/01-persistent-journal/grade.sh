#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "/var/log/journal directory exists" '[ -d /var/log/journal ]'
check_eval "journald configured Storage=persistent" \
  'grep -rEh "^\s*Storage\s*=\s*persistent" /etc/systemd/journald.conf /etc/systemd/journald.conf.d/ 2>/dev/null | grep -q .'

grade_summary
