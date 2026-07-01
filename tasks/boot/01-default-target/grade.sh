#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "default target is multi-user.target" '[ "$(systemctl get-default 2>/dev/null)" = "multi-user.target" ]'

grade_summary
