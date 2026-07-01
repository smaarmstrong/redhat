#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

SCRIPT=/usr/local/bin/checkpath.sh

check_eval "$SCRIPT exists" \
  '[ -f "$SCRIPT" ]'
check_eval "$SCRIPT is executable" \
  '[ -x "$SCRIPT" ]'

# Existing path -> EXISTS
TMPF=$(mktemp)
check_eval "prints EXISTS for a path that exists" \
  '[ "$(bash "$SCRIPT" "$TMPF" 2>/dev/null)" = "EXISTS" ]'
rm -f "$TMPF"

# Nonexistent path -> MISSING
GONE=/nonexistent/$$/$RANDOM/nope
check_eval "prints MISSING for a path that does not exist" \
  '[ "$(bash "$SCRIPT" "$GONE" 2>/dev/null)" = "MISSING" ]'

grade_summary
