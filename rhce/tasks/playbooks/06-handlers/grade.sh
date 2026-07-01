#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/handlers 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check_eval "playbook defines a handler that is notified" 'grep -q "handlers:" playbook.yml && grep -q "notify" playbook.yml'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "config file /etc/myapp.conf exists" test -f /etc/myapp.conf
check "handler marker exists (handler fired)" test -f /root/rhce/handlers/reloaded.marker
check_eval "playbook is idempotent (2nd run: changed=0, handler does not fire)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
