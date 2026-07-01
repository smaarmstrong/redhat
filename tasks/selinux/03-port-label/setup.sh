#!/usr/bin/env bash
# Clean slate: make sure 8888 is not already labelled http_port_t.
command -v semanage >/dev/null || dnf -y install policycoreutils-python-utils 2>/dev/null || true
if command -v semanage >/dev/null 2>&1; then
  semanage port -d -p tcp 8888 2>/dev/null || true
fi
exit 0
