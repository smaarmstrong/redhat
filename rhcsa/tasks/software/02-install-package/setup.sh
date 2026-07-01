#!/usr/bin/env bash
# Clean slate: make sure 'tree' is not already installed so there is work to do.
dnf -y remove tree 2>/dev/null || true
exit 0
