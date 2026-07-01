#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "/web/index.html exists" '[ -f /web/index.html ]'

check_eval "current type is httpd_sys_content_t (ls -Z)" \
  'ls -Z /web/index.html | grep -q ":httpd_sys_content_t:"'

if command -v semanage >/dev/null 2>&1; then
  check_eval "fcontext rule maps the path to httpd_sys_content_t (persistent)" \
    'semanage fcontext -l | grep -E "^/web(\\(/\\.\\*\\)\\?|/index\\.html)[[:space:]]" | grep -q "httpd_sys_content_t"'
else
  printf "  ${C_Y}note${C_0} semanage absent: cannot verify the persistent fcontext rule; a chcon-only fix will not survive restorecon/reboot\n"
fi

grade_summary
