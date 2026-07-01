#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "connection dummy0 exists" \
  'nmcli -g connection.id connection show dummy0'
check_eval "ipv4.method is manual" \
  '[ "$(nmcli -g ipv4.method connection show dummy0 2>/dev/null)" = "manual" ]'
check_eval "ipv4.addresses is 10.10.10.5/24" \
  '[ "$(nmcli -g ipv4.addresses connection show dummy0 2>/dev/null)" = "10.10.10.5/24" ]'
check_eval "ipv4.gateway is 10.10.10.1" \
  '[ "$(nmcli -g ipv4.gateway connection show dummy0 2>/dev/null)" = "10.10.10.1" ]'
check_eval "ipv4.dns is 10.10.10.53" \
  '[ "$(nmcli -g ipv4.dns connection show dummy0 2>/dev/null)" = "10.10.10.53" ]'
check_eval "connection.autoconnect is yes" \
  '[ "$(nmcli -g connection.autoconnect connection show dummy0 2>/dev/null)" = "yes" ]'

grade_summary
