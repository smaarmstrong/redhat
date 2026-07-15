#!/usr/bin/env bash
# Clean slate: a fixed sample log with mixed-case severities, in a
# world-writable practice dir (no sudo needed).
rm -rf /opt/found/loglab
mkdir -p /opt/found
install -d -m 0777 /opt/found/loglab
cat > /opt/found/loglab/app.log <<'DATA'
2026-01-05 09:12:01 INFO  service started on port 8080
2026-01-05 09:12:44 DEBUG loading plugin cache
2026-01-05 09:13:02 ERROR database connection refused
2026-01-05 09:13:02 INFO  retrying in 5 seconds
2026-01-05 09:13:07 error retry failed, giving up
2026-01-05 09:14:00 Warning disk usage above 80 percent
2026-01-05 09:14:31 DEBUG cache warm complete
2026-01-05 09:15:12 WARNING certificate expires in 10 days
2026-01-05 09:16:03 INFO  nightly backup finished
2026-01-05 09:17:45 ERROR backup verification failed
2026-01-05 09:18:20 warning swap partition in use
2026-01-05 09:19:00 INFO  all services healthy
DATA
chmod 0644 /opt/found/loglab/app.log
exit 0
