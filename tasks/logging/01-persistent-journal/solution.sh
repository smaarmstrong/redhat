#!/usr/bin/env bash
# Reference solution.
mkdir -p /etc/systemd/journald.conf.d
cat > /etc/systemd/journald.conf.d/persistent.conf <<'EOF'
[Journal]
Storage=persistent
EOF
mkdir -p /var/log/journal
systemctl restart systemd-journald
