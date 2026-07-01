Schedule a recurring cron job for user **root** that runs the script

    /usr/local/bin/backup.sh

every day at **03:30** (3:30 AM).

Use root's crontab so the schedule survives a reboot. You do not need to
create the script itself — just the crontab entry.
