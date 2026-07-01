#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/ansible-doc 2>/dev/null || true
command -v ansible-doc >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed (needed to look up the answer)"
# Expected parameter name (computed literally): the user module's login-shell param is "shell".
expected=shell
ans=$(tr -d ' \t\r\n' < answer.txt 2>/dev/null)
check "answer.txt exists" test -f answer.txt
check_eval "answer.txt is not empty" '[ -n "$ans" ]'
check_eval "answer is the correct parameter (shell)" '[ "$ans" = "$expected" ]'
grade_summary
