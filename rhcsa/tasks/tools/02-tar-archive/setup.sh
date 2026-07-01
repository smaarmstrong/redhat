#!/usr/bin/env bash
# Clean starting state: fresh /opt/logs with a few files, no prior archive.
rm -f /root/logs.tar.gz
rm -rf /opt/logs
mkdir -p /opt/logs
echo "Jan  1 00:00:00 host sshd[1]: accepted"  > /opt/logs/auth.log
echo "Jan  1 00:00:01 host kernel: booting"     > /opt/logs/kern.log
echo "Jan  1 00:00:02 host cron[9]: job ran"    > /opt/logs/cron.log
exit 0
