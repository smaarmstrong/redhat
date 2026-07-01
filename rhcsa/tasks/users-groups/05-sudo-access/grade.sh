#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "user 'opsadmin' exists" 'getent passwd opsadmin'

# Pass if EITHER the user is in wheel, OR a VALID sudoers.d file grants opsadmin.
check_eval "opsadmin has full sudo (wheel membership OR valid sudoers.d rule)" '
  in_wheel() { id -nG opsadmin 2>/dev/null | tr " " "\n" | grep -qx wheel; }
  sudoers_ok() {
    for f in /etc/sudoers.d/*; do
      [ -f "$f" ] || continue
      # File must reference opsadmin and grant ALL, and the whole sudoers set must validate.
      grep -Eq "^[[:space:]]*opsadmin[[:space:]].*ALL" "$f" \
        && grep -q "ALL[[:space:]]*$" "$f" \
        && visudo -cf "$f" >/dev/null 2>&1 \
        && return 0
    done
    return 1
  }
  in_wheel || sudoers_ok
'

grade_summary
