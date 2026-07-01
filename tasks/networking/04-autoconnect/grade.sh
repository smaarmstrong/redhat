#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "connection 'netauto' exists" \
  'nmcli -g connection.id connection show netauto'
check_eval "connection.autoconnect is yes" \
  '[ "$(nmcli -g connection.autoconnect connection show netauto 2>/dev/null)" = "yes" ]'

grade_summary
