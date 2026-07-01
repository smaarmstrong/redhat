#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/ssh-keys 2>/dev/null || true
systemctl is-active sshd >/dev/null 2>&1 || echo "  ${C_Y}note${C_0} sshd not running — this grade depends on it"
check "root has an SSH private key" bash -c 'test -f /root/.ssh/id_rsa || test -f /root/.ssh/id_ed25519 || test -f /root/.ssh/id_ecdsa'
check "ansible authorized_keys exists" test -f /home/ansible/.ssh/authorized_keys
check "authorized_keys perms are 0600" bash -c '[ "$(stat -c %a /home/ansible/.ssh/authorized_keys 2>/dev/null)" = "600" ]'
check ".ssh dir perms are 0700" bash -c '[ "$(stat -c %a /home/ansible/.ssh 2>/dev/null)" = "700" ]'
check "authorized_keys owned by ansible" bash -c '[ "$(stat -c %U /home/ansible/.ssh/authorized_keys 2>/dev/null)" = "ansible" ]'
check "root can SSH to ansible@127.0.0.1 passwordless" ssh -o BatchMode=yes -o StrictHostKeyChecking=no ansible@127.0.0.1 true
grade_summary
