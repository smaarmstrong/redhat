#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/privilege-escalation 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "a sudoers.d file for ansible exists" bash -c 'grep -rlq "^ansible[[:space:]]" /etc/sudoers.d/ 2>/dev/null'
check "grants NOPASSWD: ALL to ansible" bash -c 'grep -rEq "^ansible[[:space:]].*NOPASSWD:[[:space:]]*ALL" /etc/sudoers.d/ 2>/dev/null'
check "sudoers config validates with visudo" bash -c 'visudo -cf /etc/sudoers >/dev/null 2>&1'
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
