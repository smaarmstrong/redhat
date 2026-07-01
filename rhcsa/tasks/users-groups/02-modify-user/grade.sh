#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "user 'webadmin' exists"          'getent passwd webadmin'
check_eval "group 'webteam' exists"          'getent group webteam'
check_eval "login shell is /sbin/nologin"    '[ "$(getent passwd webadmin | cut -d: -f7)" = "/sbin/nologin" ]'
check_eval "webadmin is in group 'webteam'"  'id -nG webadmin 2>/dev/null | tr " " "\n" | grep -qx webteam'
check_eval "account is locked"               'p=$(getent shadow webadmin | cut -d: -f2); [ -n "$p" ] && [ "${p:0:1}" = "!" ]'

grade_summary
