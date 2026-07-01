#!/usr/bin/env bash
# Reference solution.
set -e

# 2. Backup destination directory (create BEFORE the script may need it).
install -d -m 0750 -o root -g root /var/backups

# 1. The backup script.
cat > /usr/local/bin/backup.sh <<'EOF'
#!/usr/bin/env bash
# Archive /etc into a gzip-compressed tarball.
set -e
mkdir -p /var/backups
tar czf /var/backups/etc-backup.tar.gz -C / etc
EOF
chmod 0755 /usr/local/bin/backup.sh

# 3. systemd service + daily timer.
cat > /etc/systemd/system/backup.service <<'EOF'
[Unit]
Description=Backup /etc to /var/backups

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF

cat > /etc/systemd/system/backup.timer <<'EOF'
[Unit]
Description=Run the /etc backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now backup.timer
