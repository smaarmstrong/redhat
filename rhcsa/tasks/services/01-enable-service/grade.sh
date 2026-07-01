#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "chronyd is enabled (starts at boot)" '[ "$(systemctl is-enabled chronyd 2>/dev/null)" = "enabled" ]'
check_eval "chronyd is active (running now)"      '[ "$(systemctl is-active chronyd 2>/dev/null)" = "active" ]'

grade_summary
