#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "group 'engineers' exists"        'getent group engineers'
check_eval "engineers GID is 4000"           '[ "$(getent group engineers | cut -d: -f3)" = "4000" ]'
check_eval "user 'alice' exists"             'getent passwd alice'
check_eval "user 'bob' exists"               'getent passwd bob'
check_eval "alice is in group 'engineers'"   'id -nG alice 2>/dev/null | tr " " "\n" | grep -qx engineers'
check_eval "bob is in group 'engineers'"     'id -nG bob 2>/dev/null | tr " " "\n" | grep -qx engineers'

grade_summary
