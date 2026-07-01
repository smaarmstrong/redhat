#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "sitecheck.service unit file exists" '[ -f /etc/systemd/system/sitecheck.service ]'
check_eval "sitecheck.timer unit file exists"   '[ -f /etc/systemd/system/sitecheck.timer ]'
check_eval "sitecheck.service is Type=oneshot"  'systemctl cat sitecheck.service 2>/dev/null | grep -Eiq "^\s*Type\s*=\s*oneshot"'
check_eval "service runs /usr/local/bin/sitecheck.sh" 'systemctl cat sitecheck.service 2>/dev/null | grep -q "/usr/local/bin/sitecheck.sh"'
check_eval "sitecheck.timer is enabled (starts at boot)" '[ "$(systemctl is-enabled sitecheck.timer 2>/dev/null)" = "enabled" ]'
check_eval "sitecheck.timer appears in list-timers" 'systemctl list-timers --all 2>/dev/null | grep -q "sitecheck.timer"'

grade_summary
