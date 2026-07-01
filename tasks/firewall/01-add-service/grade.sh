#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "firewalld is running"                 'systemctl is-active --quiet firewalld'
check_eval "http allowed in permanent config"     'firewall-cmd --permanent --query-service=http'
check_eval "http allowed in runtime config"       'firewall-cmd --query-service=http'

grade_summary
