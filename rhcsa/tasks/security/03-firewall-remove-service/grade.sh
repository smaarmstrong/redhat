#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "firewalld is running" 'systemctl is-active --quiet firewalld'

check_eval "cockpit NOT allowed in permanent config" \
  '! firewall-cmd --permanent --query-service=cockpit'

check_eval "cockpit NOT allowed in runtime config" \
  '! firewall-cmd --query-service=cockpit'

grade_summary
