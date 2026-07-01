#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "firewalld is running" 'systemctl is-active --quiet firewalld'

check_eval "cockpit NOT allowed in permanent config" \
  '! firewall-cmd --permanent --query-service=cockpit'

check_eval "cockpit NOT allowed in runtime config" \
  '! firewall-cmd --query-service=cockpit'

grade_summary
