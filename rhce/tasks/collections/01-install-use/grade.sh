#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/collection-use 2>/dev/null || true
command -v ansible-galaxy >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
if ! curl -fsI --max-time 5 https://galaxy.ansible.com/ >/dev/null 2>&1; then
  echo "  ${C_Y}note${C_0} no network to Ansible Galaxy — this bonus task needs internet access"
fi
check "collections/requirements.yml exists" test -f collections/requirements.yml
check "requirements names community.general" bash -c 'grep -q "community.general" collections/requirements.yml'
check "playbook.yml exists" test -f playbook.yml
check "community.general collection installed" bash -c 'ansible-galaxy collection list 2>/dev/null | grep -q community.general'
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "/etc/myapp.ini created" test -f /etc/myapp.ini
grade_summary
