#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# Modules require AppStream metadata. If the module isn't even known here,
# explain why rather than just failing.
if ! dnf -q module list postgresql >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} the 'postgresql' module is unavailable — no AppStream repo with module metadata is configured.\n"
fi

# The version-15 stream is enabled if `dnf module list` marks the 15 stream
# with [e], OR the persistent state file records stream = 15.
stream_enabled() {
  dnf -q module list postgresql 2>/dev/null \
    | grep -E '^[[:space:]]*postgresql[[:space:]]+15\b' \
    | grep -q '\[e\]' \
  || grep -Eqs '^[[:space:]]*stream[[:space:]]*=[[:space:]]*15[[:space:]]*$' \
       /etc/dnf/modules.d/postgresql.module
}

check_eval "postgresql module stream 15 is enabled" 'stream_enabled'

grade_summary
