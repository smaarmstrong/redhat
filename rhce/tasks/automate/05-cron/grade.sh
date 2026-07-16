#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/cron 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check_eval "root crontab has the 15 2 * * * schedule for backup.sh" 'crontab -l 2>/dev/null | grep -Eq "^15[[:space:]]+2[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+.*/usr/local/bin/backup.sh"'
check_eval "cron entry is named nightly-backup" 'crontab -l 2>/dev/null | grep -q "nightly-backup"'
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
