#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

# Primary, robust check: the persistent drop-in exists and sets umask 077.
check_eval "/etc/profile.d/umask.sh exists and is readable" \
  '[ -r /etc/profile.d/umask.sh ]'

# Accept "umask 077" or "umask 0077", ignoring leading whitespace/comments.
check_eval "it sets 'umask 077' (persistent)" \
  'grep -Eq "^[[:space:]]*umask[[:space:]]+0?077[[:space:]]*$" /etc/profile.d/umask.sh'

# Confirm a fresh login shell actually yields 0077.
check_eval "a fresh login shell reports umask 0077 (bash -lc umask)" \
  '[ "$(bash -lc umask 2>/dev/null)" = "0077" ]'

grade_summary
