#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/adhoc-script 2>/dev/null || true
command -v ansible >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "check.sh exists" test -f check.sh
check "check.sh is executable" test -x check.sh
check "check.sh invokes ansible with the ping module" bash -c 'grep -Eq "ansible.*(-m[[:space:]]+ping|ping)" check.sh'
check "check.sh runs and exits 0" ./check.sh
grade_summary
