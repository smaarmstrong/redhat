#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

SSHDIR=/home/nadia/.ssh
AKEYS="$SSHDIR/authorized_keys"

# sshd must be running for the login test to have any chance of passing.
if ! systemctl is-active --quiet sshd; then
  printf "  ${C_Y}note${C_0} sshd is not running — the passwordless login check cannot pass.\n"
fi

# Shadow fields for nadia: 4=min 5=max 6=warn. Read once, guard empties.
shadow="$(getent shadow nadia 2>/dev/null)"
smin="$(printf '%s' "$shadow" | cut -d: -f4)"
smax="$(printf '%s' "$shadow" | cut -d: -f5)"
swarn="$(printf '%s' "$shadow" | cut -d: -f6)"

# --- 1. group + user identity ------------------------------------------------
check_eval "group 'engineering' exists"          'getent group engineering'
check_eval "engineering GID is 5000"             '[ "$(getent group engineering | cut -d: -f3)" = 5000 ]'
check_eval "user 'nadia' exists"                 'getent passwd nadia'
check_eval "nadia is a member of engineering"    'id -nG nadia 2>/dev/null | tr " " "\n" | grep -qx engineering'
check_eval "nadia GECOS is 'Nadia Ops'"          '[ "$(getent passwd nadia | cut -d: -f5)" = "Nadia Ops" ]'
check_eval "nadia login shell is /bin/bash"      '[ "$(getent passwd nadia | cut -d: -f7)" = "/bin/bash" ]'

# --- 2. sudo via validated drop-in -------------------------------------------
check_eval "a validated sudoers.d rule grants nadia full sudo" '
  ok=1
  for f in /etc/sudoers.d/*; do
    [ -f "$f" ] || continue
    if grep -Eq "^[[:space:]]*nadia[[:space:]].*ALL" "$f" \
       && grep -Eq "ALL[[:space:]]*$" "$f" \
       && visudo -cf "$f" >/dev/null 2>&1; then
      ok=0; break
    fi
  done
  [ "$ok" -eq 0 ]
'

# --- 3. password aging -------------------------------------------------------
check_eval "password max age is 90 days"         '[ "$smax" = 90 ]'
check_eval "password min age is 1 day"           '[ "$smin" = 1 ]'
check_eval "password warning period is 14 days"  '[ "$swarn" = 14 ]'

# --- 4. SSH key-based auth ---------------------------------------------------
check_eval "$SSHDIR exists"                       '[ -d "$SSHDIR" ]'
check_eval "$SSHDIR is mode 700"                  '[ "$(stat -c %a "$SSHDIR" 2>/dev/null)" = 700 ]'
check_eval "$SSHDIR is owned by nadia"            '[ "$(stat -c %U "$SSHDIR" 2>/dev/null)" = nadia ]'
check_eval "authorized_keys exists"               '[ -f "$AKEYS" ]'
check_eval "authorized_keys is mode 600"          '[ "$(stat -c %a "$AKEYS" 2>/dev/null)" = 600 ]'
check_eval "authorized_keys is owned by nadia"    '[ "$(stat -c %U "$AKEYS" 2>/dev/null)" = nadia ]'
check_eval "authorized_keys holds a valid public key" \
  '[ -s "$AKEYS" ] && ssh-keygen -l -f "$AKEYS" >/dev/null 2>&1'
check_eval "root can ssh to nadia@localhost via key (no password)" \
  'ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 nadia@localhost true'

# --- 5. project directory ----------------------------------------------------
check_eval "/home/nadia/reports exists"           '[ -d /home/nadia/reports ]'
check_eval "reports owned by nadia"               '[ "$(stat -c %U /home/nadia/reports 2>/dev/null)" = nadia ]'
check_eval "reports group is engineering"         '[ "$(stat -c %G /home/nadia/reports 2>/dev/null)" = engineering ]'
check_eval "reports mode is 2770 (setgid)"        '[ "$(stat -c %a /home/nadia/reports 2>/dev/null)" = 2770 ]'

grade_summary
