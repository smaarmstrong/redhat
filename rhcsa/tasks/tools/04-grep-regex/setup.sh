#!/usr/bin/env bash
# Clean slate, then write a fixed sample log with a mix of matching /
# non-matching lines. Idempotent: the file is fully rewritten each time.
rm -f /root/ips.txt

cat > /var/log/access.sample <<'EOF'
Jan 01 08:00:01 host sshd: accepted connection from 192.168.1.20
Jan 01 08:00:05 host cron: running daily job
Jan 01 08:01:11 host sshd: failed login from 10.0.0.5 user root
Jan 01 08:02:00 host kernel: usb device connected
Client at 172.16.254.1 requested /index.html
No address on this line at all
Backup completed to /srv/backup successfully
Ping reply from 8.8.8.8 time=12ms
warning: disk usage at 85 percent
gateway is 192.168.0.1 on eth0
DNS lookup for example.com returned nothing useful
Connection reset by peer 203.0.113.42
Reading configuration from /etc/app.conf
Malformed line 999.999.999.999 should still match the pattern
user alice logged out
Traffic seen from 127.0.0.1 loopback
temperature reading 36.6 degrees today
Route added via 10.10.10.254 metric 100
Nothing numeric here whatsoever
Session opened for 198.51.100.7 port 443
EOF

chmod 644 /var/log/access.sample
exit 0
