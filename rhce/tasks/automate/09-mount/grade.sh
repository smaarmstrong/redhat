#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/mount 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
ansible-galaxy collection list ansible.posix >/dev/null 2>&1 || echo "  ${C_Y}note${C_0} ansible.posix collection (mount module) not installed"
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check playbook.yml >/dev/null 2>&1'
check "playbook runs successfully" bash -c 'ansible-playbook playbook.yml >/dev/null 2>&1'
check_eval "/mnt/ramdisk is mounted as tmpfs" "findmnt -no FSTYPE /mnt/ramdisk 2>/dev/null | grep -qx tmpfs"
check_eval "fstab has a tmpfs entry for /mnt/ramdisk" "grep -Eq '^[^#]*[[:space:]]/mnt/ramdisk[[:space:]]+tmpfs' /etc/fstab"
check_eval "playbook is idempotent (2nd run: changed=0)" 'ansible-playbook playbook.yml 2>/dev/null | grep -Eq "changed=0.*failed=0"'
grade_summary
