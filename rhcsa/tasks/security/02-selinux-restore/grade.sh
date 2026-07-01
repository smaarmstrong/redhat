#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "/var/www/page.html exists" '[ -f /var/www/page.html ]'

if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
  check_eval "SELinux type is httpd_sys_content_t (ls -Z)" \
    'ls -Z /var/www/page.html 2>/dev/null | grep -q ":httpd_sys_content_t:"'
else
  printf "  ${C_Y}note${C_0} SELinux is disabled: cannot verify the file context; enable SELinux to grade this task\n"
fi

grade_summary
