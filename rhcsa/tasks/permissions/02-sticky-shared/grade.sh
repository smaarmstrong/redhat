#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "/srv/dropbox exists and is a directory" '[ -d /srv/dropbox ]'
check_eval "mode is 1777 (sticky + world-writable)"  '[ "$(stat -c %a /srv/dropbox 2>/dev/null)" = 1777 ]'

grade_summary
