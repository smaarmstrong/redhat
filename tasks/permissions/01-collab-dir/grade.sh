#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "group 'developers' exists"          'getent group developers'
check_eval "/srv/devshare exists and is a directory" '[ -d /srv/devshare ]'
check_eval "group owner is 'developers'"        '[ "$(stat -c %G /srv/devshare 2>/dev/null)" = developers ]'
check_eval "mode is 2770 (setgid, rwx group, no other)" '[ "$(stat -c %a /srv/devshare 2>/dev/null)" = 2770 ]'

grade_summary
