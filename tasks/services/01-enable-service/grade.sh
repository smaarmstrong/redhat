#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "chronyd is enabled (starts at boot)" '[ "$(systemctl is-enabled chronyd 2>/dev/null)" = "enabled" ]'
check_eval "chronyd is active (running now)"      '[ "$(systemctl is-active chronyd 2>/dev/null)" = "active" ]'

grade_summary
