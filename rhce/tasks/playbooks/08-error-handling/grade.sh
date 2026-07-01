#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/error-handling 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check_eval "playbook uses block/rescue" 'grep -q "block:" playbook.yml && grep -q "rescue:" playbook.yml'
check "playbook run succeeds (exit 0)" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "recovered.txt exists (rescue ran)" test -f /root/rhce/error-handling/recovered.txt
grade_summary
