#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

if command -v semanage >/dev/null 2>&1; then
  # A matching http_port_t line whose port list contains 8888 (whole number).
  check_eval "TCP 8888 is labelled http_port_t (semanage port -l)" \
    'semanage port -l | grep "^http_port_t" | grep -E "\btcp\b" | grep -qE "(^|[ ,])8888([ ,]|$)"'
else
  printf "  ${C_Y}note${C_0} semanage absent: SELinux port labels require semanage (policycoreutils-python-utils); cannot grade this task\n"
  check_eval "semanage available to manage/verify port labels" 'false'
fi

grade_summary
