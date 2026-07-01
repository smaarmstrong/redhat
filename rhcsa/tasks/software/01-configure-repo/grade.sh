#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

REPO=/etc/yum.repos.d/local.repo

# Extract only the [localdvd] section so keys from other stanzas can't leak in.
section() {
  awk '/^\[/{f=($0=="["id"]")} f' id=localdvd "$REPO" 2>/dev/null
}

check_eval "$REPO exists" \
  '[ -f "$REPO" ]'
check_eval "has a [localdvd] section" \
  'grep -Eq "^\[localdvd\]" "$REPO"'
check_eval "baseurl is file:///mnt/dvd/BaseOS" \
  'section | grep -Eq "^[[:space:]]*baseurl[[:space:]]*=[[:space:]]*file:///mnt/dvd/BaseOS[[:space:]]*$"'
check_eval "enabled = 1" \
  'section | grep -Eq "^[[:space:]]*enabled[[:space:]]*=[[:space:]]*1[[:space:]]*$"'
check_eval "gpgcheck = 0" \
  'section | grep -Eq "^[[:space:]]*gpgcheck[[:space:]]*=[[:space:]]*0[[:space:]]*$"'

grade_summary
