#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

# Pass only if no process matching the runaway hog is still running.
check_eval "no 'runaway-hog' process is running" '! pgrep -f runaway-hog >/dev/null 2>&1'

grade_summary
