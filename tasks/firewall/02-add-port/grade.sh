#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "firewalld is running"                 'systemctl is-active --quiet firewalld'
check_eval "8080/tcp open in permanent config"    'firewall-cmd --permanent --query-port=8080/tcp'
check_eval "8080/tcp open in runtime config"      'firewall-cmd --query-port=8080/tcp'

grade_summary
