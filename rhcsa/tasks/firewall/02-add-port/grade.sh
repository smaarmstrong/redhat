#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "firewalld is running"                 'systemctl is-active --quiet firewalld'
check_eval "8080/tcp open in permanent config"    'firewall-cmd --permanent --query-port=8080/tcp'
check_eval "8080/tcp open in runtime config"      'firewall-cmd --query-port=8080/tcp'

grade_summary
