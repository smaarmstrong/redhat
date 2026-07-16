#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/galaxy-install 2>/dev/null || true
command -v ansible-galaxy >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
if ! curl -fsI --max-time 5 https://galaxy.ansible.com/ >/dev/null 2>&1; then
  echo "  ${C_Y}note${C_0} no network to Ansible Galaxy — this bonus task needs internet access"
fi
check "requirements.yml exists" test -f requirements.yml
check "requirements.yml names geerlingguy.ntp" bash -c 'grep -q "geerlingguy.ntp" requirements.yml'
check "role geerlingguy.ntp installed under roles/" test -d roles/geerlingguy.ntp
check "installed role has tasks/main.yml" test -f roles/geerlingguy.ntp/tasks/main.yml
grade_summary
