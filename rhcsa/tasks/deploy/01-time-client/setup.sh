#!/usr/bin/env bash
# Ensure chrony is present (best-effort; no internet assumed) and that the
# target server line is absent so there is work to do.

command -v chronyd >/dev/null 2>&1 || dnf -y install chrony 2>/dev/null || true

# Remove any pre-existing time.cloudflare.com server line from the main config
# and from any drop-in, so the task starts clean.
if [ -f /etc/chrony.conf ]; then
  sed -i '/^[[:space:]]*server[[:space:]]\+time\.cloudflare\.com\b/d' /etc/chrony.conf 2>/dev/null
fi
if [ -d /etc/chrony.d ]; then
  for f in /etc/chrony.d/*.conf; do
    [ -f "$f" ] || continue
    sed -i '/^[[:space:]]*server[[:space:]]\+time\.cloudflare\.com\b/d' "$f" 2>/dev/null
  done
fi

exit 0
