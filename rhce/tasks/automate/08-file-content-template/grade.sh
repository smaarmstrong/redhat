#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/motd-content 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "/etc/motd exists" test -f /etc/motd
check_eval "/etc/motd first line matches" "[ \"\$(sed -n 1p /etc/motd)\" = 'Authorized access only.' ]"
check_eval "/etc/motd second line matches" "[ \"\$(sed -n 2p /etc/motd)\" = 'Managed by Ansible.' ]"
check_eval "/etc/motd has exactly two content lines" "[ \"\$(grep -c . /etc/motd)\" -eq 2 ]"
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
