#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

if ! command -v tuned-adm >/dev/null 2>&1; then
  echo "  NOTE: tuned-adm is not installed; cannot grade this task on this system."
fi

check_eval "active tuned profile is 'powersave'" \
  'tuned-adm active 2>/dev/null | grep -Eq "Current active profile:\s*powersave"'

grade_summary
