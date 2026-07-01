#!/usr/bin/env bash
# Clean slate: (re)create /web/index.html and give it a WRONG context.
command -v semanage >/dev/null || dnf -y install policycoreutils-python-utils 2>/dev/null || true

# Remove any leftover fcontext rule from a prior attempt.
if command -v semanage >/dev/null 2>&1; then
  semanage fcontext -d '/web(/.*)?' 2>/dev/null || true
  semanage fcontext -d '/web/index.html' 2>/dev/null || true
fi

mkdir -p /web
echo "hello" > /web/index.html
# Force a deliberately wrong type so there is work to do.
chcon -t tmp_t /web/index.html 2>/dev/null || true
exit 0
