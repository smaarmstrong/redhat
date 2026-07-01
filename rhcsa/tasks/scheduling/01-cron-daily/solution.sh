#!/usr/bin/env bash
# Reference solution.
( crontab -l 2>/dev/null | grep -v '/usr/local/bin/backup.sh'
  echo "30 3 * * * /usr/local/bin/backup.sh"
) | crontab -
