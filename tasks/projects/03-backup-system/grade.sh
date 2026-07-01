#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

SCRIPT=/usr/local/bin/backup.sh
ARCHIVE=/var/backups/etc-backup.tar.gz

# --- 1. the backup script ----------------------------------------------------
check_eval "$SCRIPT exists"                       '[ -f "$SCRIPT" ]'
check_eval "$SCRIPT is executable"                '[ -x "$SCRIPT" ]'

# Actually RUN the learner's script and verify it produces a valid gzip tar of
# /etc. We remove any pre-existing archive first so we are grading THIS run,
# and cap the runtime so a broken script cannot hang the grader.
rm -f "$ARCHIVE" 2>/dev/null
if [ -x "$SCRIPT" ]; then
  timeout 120 "$SCRIPT" >/dev/null 2>&1
fi

check_eval "running $SCRIPT produced $ARCHIVE"    '[ -f "$ARCHIVE" ]'
check_eval "archive is gzip-compressed data"     'file -b "$ARCHIVE" 2>/dev/null | grep -qi gzip'
check_eval "archive is a valid tar (lists ok)"   'tar -tzf "$ARCHIVE" >/dev/null 2>&1'
check_eval "archive actually contains /etc content" \
  'tar -tzf "$ARCHIVE" 2>/dev/null | grep -Eq "(^|/)etc/"'

# --- 2. /var/backups directory ----------------------------------------------
check_eval "/var/backups exists and is a directory" '[ -d /var/backups ]'
check_eval "/var/backups owned by root"           '[ "$(stat -c %U /var/backups 2>/dev/null)" = root ]'
check_eval "/var/backups group is root"           '[ "$(stat -c %G /var/backups 2>/dev/null)" = root ]'
check_eval "/var/backups mode is 0750"            '[ "$(stat -c %a /var/backups 2>/dev/null)" = 750 ]'

# --- 3. systemd service + timer ---------------------------------------------
check_eval "backup.service unit file exists"      '[ -f /etc/systemd/system/backup.service ]'
check_eval "backup.timer unit file exists"        '[ -f /etc/systemd/system/backup.timer ]'
check_eval "backup.service is Type=oneshot"       'systemctl cat backup.service 2>/dev/null | grep -Eiq "^[[:space:]]*Type[[:space:]]*=[[:space:]]*oneshot"'
check_eval "backup.service ExecStart runs the script" 'systemctl cat backup.service 2>/dev/null | grep -Eq "^[[:space:]]*ExecStart[[:space:]]*=.*/usr/local/bin/backup\.sh"'
check_eval "backup.timer is enabled (starts at boot)" '[ "$(systemctl is-enabled backup.timer 2>/dev/null)" = "enabled" ]'
check_eval "backup.timer appears in list-timers"  'systemctl list-timers --all 2>/dev/null | grep -q "backup.timer"'

grade_summary
