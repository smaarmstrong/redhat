#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/file-content 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
f=/etc/security/limits.d/99-custom.conf
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "target file exists" test -f "$f"
check_eval "file contains the exact nofile line" "grep -Fxq '* soft nofile 4096' '$f'"
check_eval "file has the ansible managed block markers" "grep -Fq 'BEGIN ANSIBLE MANAGED BLOCK' '$f' && grep -Fq 'END ANSIBLE MANAGED BLOCK' '$f'"
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
