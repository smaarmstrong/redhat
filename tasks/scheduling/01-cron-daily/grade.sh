#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "root crontab runs /usr/local/bin/backup.sh daily at 03:30" \
  'crontab -l 2>/dev/null | grep -Eq "^\s*30\s+3\s+\*\s+\*\s+\*\s+/usr/local/bin/backup.sh"'

grade_summary
