#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/firewall 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
command -v firewall-cmd >/dev/null || echo "  ${C_Y}note${C_0} firewalld not available — firewall checks will fail"
if command -v ansible-galaxy >/dev/null && ! ansible-galaxy collection list 2>/dev/null | grep -q 'ansible.posix'; then
  echo "  ${C_Y}note${C_0} ansible.posix collection not installed — firewalld module may be unavailable"
fi
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "http allowed permanently" firewall-cmd --permanent --query-service=http
check "http allowed in runtime config" firewall-cmd --query-service=http
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
