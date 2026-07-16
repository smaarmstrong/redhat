#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/selinux 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
ansible-galaxy collection list ansible.posix >/dev/null 2>&1 || echo "  ${C_Y}note${C_0} ansible.posix collection (seboolean module) not installed"
command -v getsebool >/dev/null || echo "  ${C_Y}note${C_0} SELinux userspace tools absent — boolean checks depend on a working SELinux"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check_eval "httpd_can_network_connect is on (current)" "getsebool httpd_can_network_connect 2>/dev/null | grep -q ' on\$'"
# If semanage is available, confirm the change is persistent (default value flipped on).
check_eval "httpd_can_network_connect persisted (semanage, if present)" "! command -v semanage >/dev/null || semanage boolean -l 2>/dev/null | grep -E '^httpd_can_network_connect' | grep -Eq '\(on[[:space:]]*,'"
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
