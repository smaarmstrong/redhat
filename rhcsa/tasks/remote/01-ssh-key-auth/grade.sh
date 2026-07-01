#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

SSHDIR=/home/deploy/.ssh
AKEYS="$SSHDIR/authorized_keys"

# The sshd service must be running for key auth to be testable at all.
if ! systemctl is-active --quiet sshd; then
  echo "  ${C_Y}note${C_0}: sshd is not running — the login check below cannot pass."
fi

check_eval "$SSHDIR exists"                     '[ -d "$SSHDIR" ]'
check_eval "$SSHDIR is mode 700"                '[ "$(stat -c %a "$SSHDIR" 2>/dev/null)" = 700 ]'
check_eval "$SSHDIR is owned by deploy"         '[ "$(stat -c %U "$SSHDIR" 2>/dev/null)" = deploy ]'
check_eval "authorized_keys exists"             '[ -f "$AKEYS" ]'
check_eval "authorized_keys is mode 600"        '[ "$(stat -c %a "$AKEYS" 2>/dev/null)" = 600 ]'
check_eval "authorized_keys is owned by deploy" '[ "$(stat -c %U "$AKEYS" 2>/dev/null)" = deploy ]'
check_eval "authorized_keys holds a valid public key" \
  '[ -s "$AKEYS" ] && ssh-keygen -l -f "$AKEYS" >/dev/null 2>&1'

# The real test: root can log in to deploy@localhost with no password.
check_eval "root can ssh to deploy@localhost via key (no password)" \
  'ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 deploy@localhost true'

grade_summary
