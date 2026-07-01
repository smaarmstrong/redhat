#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

APP=org.gnome.Calculator

# Flatpak is not part of a Rocky 9 base install. If it's absent, explain
# rather than just failing.
if ! command -v flatpak >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} 'flatpak' is not installed — this bonus task needs flatpak, the flathub remote, and internet access.\n"
  grade_summary
  exit $?
fi

# Without the flathub remote the app cannot be installed; explain if missing.
if ! flatpak remotes 2>/dev/null | awk '{print $1}' | grep -qx flathub; then
  printf "  ${C_Y}note${C_0} the 'flathub' remote is not configured — add it first (see the flatpak-repo task).\n"
fi

check_eval "$APP is installed" \
  'flatpak list --columns=application 2>/dev/null | grep -qx "$APP"'

grade_summary
