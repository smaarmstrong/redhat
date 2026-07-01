#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/packages-repo 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "repo file /etc/yum.repos.d/localdvd.repo exists" test -f /etc/yum.repos.d/localdvd.repo
check_eval "repo id [localdvd] present" 'grep -Eq "^\[localdvd\]" /etc/yum.repos.d/localdvd.repo'
check_eval "baseurl is file:///mnt/dvd/BaseOS" 'grep -Eq "^baseurl[[:space:]]*=[[:space:]]*file:///mnt/dvd/BaseOS" /etc/yum.repos.d/localdvd.repo'
check_eval "gpgcheck is disabled" 'grep -Eiq "^gpgcheck[[:space:]]*=[[:space:]]*(0|no|false)" /etc/yum.repos.d/localdvd.repo'
check "tree package is installed" rpm -q tree
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
