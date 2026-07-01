#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# Build the expected set the same way the learner should: every rhcsa-drill
# journal line containing 4711. Compare trimmed + sorted to tolerate ordering
# and incidental trailing whitespace.
expected=$(journalctl -t rhcsa-drill --no-pager 2>/dev/null | grep 4711 | sed 's/[[:space:]]*$//' | sort)

check_eval "/root/drill.txt exists" '[ -f /root/drill.txt ]'
check_eval "at least one 4711 line was captured" '[ -n "$expected" ]'
check_eval "/root/drill.txt matches the expected 4711 journal lines" \
  '[ "$(sed "s/[[:space:]]*$//" /root/drill.txt 2>/dev/null | sort)" = "$expected" ]'

grade_summary
