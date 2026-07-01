#!/usr/bin/env bash
# Clean slate: remove any prior entry for this IP or these names.
if [ -f /etc/hosts ]; then
  sed -i -e '/192\.168\.55\.10/d' -e '/[[:space:]]db\.example\.com/d' /etc/hosts
fi
exit 0
