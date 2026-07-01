#!/usr/bin/env bash
# Idempotent clean start: remove the script, the produced archive, the unit
# files, and disable/forget the timer from any prior attempt. Leave
# /var/backups behavior to the learner (remove it so mode/owner is graded fresh).

# Disable + stop the timer/service if a prior attempt installed them.
systemctl disable --now backup.timer  >/dev/null 2>&1
systemctl stop        backup.service  >/dev/null 2>&1

rm -f /etc/systemd/system/backup.service 2>/dev/null
rm -f /etc/systemd/system/backup.timer   2>/dev/null
systemctl daemon-reload >/dev/null 2>&1

rm -f /usr/local/bin/backup.sh 2>/dev/null

# Remove the backups directory (and any stale archive) so perms are graded clean.
rm -rf /var/backups 2>/dev/null

exit 0
