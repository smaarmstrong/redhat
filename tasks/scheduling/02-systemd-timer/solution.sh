#!/usr/bin/env bash
# Reference solution.
cat > /etc/systemd/system/sitecheck.service <<'EOF'
[Unit]
Description=Site check maintenance task

[Service]
Type=oneshot
ExecStart=/usr/local/bin/sitecheck.sh
EOF

cat > /etc/systemd/system/sitecheck.timer <<'EOF'
[Unit]
Description=Run sitecheck daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now sitecheck.timer
