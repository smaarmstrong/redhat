#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/create-role 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "role dir roles/webconfig exists" test -d roles/webconfig
check "role tasks/main.yml exists" test -f roles/webconfig/tasks/main.yml
check "site.yml exists" test -f site.yml
check "site.yml syntax is valid" bash -c 'ansible-playbook --syntax-check site.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook site.yml >/dev/null 2>&1'
check "/etc/myapp/app.conf exists" test -f /etc/myapp/app.conf
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook site.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
