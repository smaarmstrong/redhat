#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# Pass only if no process matching the runaway hog is still running.
check_eval "no 'runaway-hog' process is running" '! pgrep -f runaway-hog >/dev/null 2>&1'

grade_summary
