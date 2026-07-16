#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/users-groups 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "group devs exists" bash -c 'getent group devs >/dev/null'
check_eval "group devs has GID 6000" '[ "$(getent group devs | cut -d: -f3)" = 6000 ]'
check "user deploybot exists" bash -c 'getent passwd deploybot >/dev/null'
check_eval "deploybot is a member of devs" 'id -nG deploybot 2>/dev/null | tr " " "\n" | grep -qx devs'
check_eval "deploybot has a comment/GECOS" '[ -n "$(getent passwd deploybot | cut -d: -f5)" ]'
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
