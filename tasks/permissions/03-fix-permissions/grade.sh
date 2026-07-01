#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "user 'intern' exists"                 'getent passwd intern'
check_eval "/srv/reports/report.txt exists"       '[ -f /srv/reports/report.txt ]'
check_eval "'intern' can traverse /srv/reports"   'sudo -u intern test -x /srv/reports'
check_eval "'intern' can read report.txt"         'sudo -u intern test -r /srv/reports/report.txt'
check_eval "'intern' can actually cat the file"   'sudo -u intern cat /srv/reports/report.txt'

grade_summary
