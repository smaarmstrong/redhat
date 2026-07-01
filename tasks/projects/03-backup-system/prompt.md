PROJECT: Scheduled configuration backup

Build an automated daily backup of /etc, driven by a systemd timer. The pieces
must persist across reboot.

Requirements:

  1. Write a backup script at /usr/local/bin/backup.sh that creates a
     gzip-compressed tar archive of the /etc directory at
     /var/backups/etc-backup.tar.gz. The script must be executable and must
     work when run as root with no arguments (it will be run to verify it
     actually produces a valid archive).

  2. Create the directory /var/backups owned by root:root with mode 0750.

  3. Create a systemd service unit named backup.service:
       • Type=oneshot
       • ExecStart runs /usr/local/bin/backup.sh
     and a systemd timer unit named backup.timer that triggers it daily.
     ENABLE the timer so it starts at boot (it must appear in
     `systemctl list-timers`).

Hint: `tar czf /var/backups/etc-backup.tar.gz -C / etc` is a clean way to
archive /etc. The grader will RUN your script, so make sure it exits 0 and
leaves a valid gzip tar behind.
