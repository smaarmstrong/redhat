#!/usr/bin/env bash
# Clean slate: (re)create /var/www/page.html and give it a WRONG SELinux type.
mkdir -p /var/www
echo "<html><body>hello</body></html>" > /var/www/page.html

# Only meaningful when SELinux is active; harmless otherwise.
if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
  # Ensure the directory itself carries the expected default label, so the only
  # thing wrong is the file we deliberately mislabel below.
  restorecon /var/www 2>/dev/null || true
  # Deliberately mislabel the file so there is work to do.
  chcon -t user_home_t /var/www/page.html 2>/dev/null \
    || chcon -t tmp_t /var/www/page.html 2>/dev/null || true
fi
exit 0
