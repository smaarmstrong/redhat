#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

# Flatpak is not part of a Rocky 9 base install. If it's absent, explain
# rather than just failing.
if ! command -v flatpak >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} 'flatpak' is not installed — this bonus task needs flatpak and internet access.\n"
  grade_summary
  exit $?
fi

check_eval "a remote named 'flathub' is configured" \
  'flatpak remotes 2>/dev/null | awk "{print \$1}" | grep -qx flathub'

grade_summary
