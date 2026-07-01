#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# /etc/shadow fields: 4=min age, 5=max age, 6=warn days
check_eval "user 'appuser' exists"      'getent passwd appuser'
check_eval "minimum age is 1 day"       '[ "$(getent shadow appuser | cut -d: -f4)" = "1" ]'
check_eval "maximum age is 60 days"     '[ "$(getent shadow appuser | cut -d: -f5)" = "60" ]'
check_eval "warning period is 7 days"   '[ "$(getent shadow appuser | cut -d: -f6)" = "7" ]'

grade_summary
