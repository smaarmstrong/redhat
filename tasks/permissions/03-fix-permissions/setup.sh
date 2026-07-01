#!/usr/bin/env bash
# Create the 'intern' user and a report the user genuinely cannot read.
id intern >/dev/null 2>&1 || useradd -m intern

mkdir -p /srv/reports
echo "Quarterly figures — confidential." > /srv/reports/report.txt

# Wrong ownership and permissions: root-owned, mode 600 => intern cannot read.
chown root:root /srv/reports/report.txt
chmod 600 /srv/reports/report.txt

# Directory is traversable by others so the task is specifically about the
# file. (It is still traversable, but the file itself is unreadable.)
chown root:root /srv/reports
chmod 755 /srv/reports

# Clear any stale ACLs from a previous attempt.
setfacl -b /srv/reports/report.txt 2>/dev/null
setfacl -b /srv/reports 2>/dev/null
exit 0
