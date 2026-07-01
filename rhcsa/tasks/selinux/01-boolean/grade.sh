#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "httpd_can_network_connect is ON (runtime)" \
  '[ "$(getsebool httpd_can_network_connect | awk "{print \$3}")" = "on" ]'

if command -v semanage >/dev/null 2>&1; then
  # semanage boolean -l prints: name  (current , persisted)  description
  # Normalise whitespace, then require the state pair to be exactly (on,on).
  check_eval "boolean persisted as ON (semanage current+persisted)" \
    'semanage boolean -l | grep -E "^httpd_can_network_connect\b" | tr -d " " | grep -q "(on,on)"'
else
  printf "  ${C_Y}note${C_0} semanage absent: cannot verify persisted value; -P is required for reboot persistence\n"
fi

grade_summary
