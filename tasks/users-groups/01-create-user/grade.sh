#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "user 'dbuser' exists"           'getent passwd dbuser'
check_eval "UID is 1500"                     '[ "$(id -u dbuser 2>/dev/null)" = 1500 ]'
check_eval "comment (GECOS) is 'Database User'" '[ "$(getent passwd dbuser | cut -d: -f5)" = "Database User" ]'
check_eval "login shell is /bin/bash"        '[ "$(getent passwd dbuser | cut -d: -f7)" = "/bin/bash" ]'

grade_summary
