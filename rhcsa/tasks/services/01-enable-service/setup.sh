#!/usr/bin/env bash
# Start from a clean slate: disable and stop chronyd so there is work to do.
systemctl disable --now chronyd 2>/dev/null
exit 0
