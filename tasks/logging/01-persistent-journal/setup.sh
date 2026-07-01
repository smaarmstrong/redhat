#!/usr/bin/env bash
# Start from a clean slate: force volatile (in-memory) journald storage.
rm -rf /var/log/journal
rm -f /etc/systemd/journald.conf.d/*persistent*.conf 2>/dev/null

conf=/etc/systemd/journald.conf
if [ -f "$conf" ]; then
  # Drop any existing Storage= line, then pin it to volatile.
  sed -i '/^\s*#\?\s*Storage\s*=/Id' "$conf"
  printf '\n[Journal]\nStorage=volatile\n' >> "$conf"
fi

systemctl restart systemd-journald 2>/dev/null
exit 0
