#!/usr/bin/env bash
# Start from a clean slate: set the default to graphical.target so there is work.
systemctl set-default graphical.target 2>/dev/null
exit 0
