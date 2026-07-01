#!/usr/bin/env bash
# Clean slate: drop to permissive at runtime AND in the boot config.
setenforce 0 2>/dev/null || true
if [ -f /etc/selinux/config ]; then
  sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
fi
exit 0
