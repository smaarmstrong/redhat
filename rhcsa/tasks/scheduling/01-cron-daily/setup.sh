#!/usr/bin/env bash
# Start from a clean slate: strip any prior backup.sh line from root's crontab.
if crontab -l >/dev/null 2>&1; then
  crontab -l 2>/dev/null | grep -v '/usr/local/bin/backup.sh' | crontab -
fi
exit 0
