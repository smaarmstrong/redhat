#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

F=/home/operator/created-by-me.txt

check_eval "file $F exists"           '[ -f "$F" ]'
check_eval "file is owned by operator" '[ -f "$F" ] && [ "$(stat -c %U "$F")" = "operator" ]'
check_eval "file is in operator's home" '[ -f "$F" ] && [ "$(dirname "$F")" = "$(getent passwd operator | cut -d: -f6)" ]'

grade_summary
