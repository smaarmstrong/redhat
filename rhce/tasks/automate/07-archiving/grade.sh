#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/archiving 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
ansible-galaxy collection list community.general >/dev/null 2>&1 || echo "  ${C_Y}note${C_0} community.general collection (archive module) not installed"
a=/root/rhce/archiving/etc-backup.tar.gz
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check "archive file exists" test -f "$a"
check_eval "archive is a valid gzip tarball" "tar -tzf '$a' >/dev/null 2>&1"
check_eval "archive contains ssh config members" "tar -tzf '$a' 2>/dev/null | grep -q 'sshd_config'"
# The archive module is idempotent on an unchanged source tree; if the platform's
# tar/gzip embeds timestamps that defeat this, the file-exists + valid checks above
# still confirm a correct end state.
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
