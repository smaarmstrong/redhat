#!/usr/bin/env bash
# Clean slate: (re)create a dummy interface + connection to configure against.
# Configuring this profile cannot break the machine's real connectivity.

# Remove any prior profile so the task starts with defaults.
nmcli connection delete dummy0 2>/dev/null

# Create the dummy connection bound to a dummy interface.
nmcli connection add type dummy ifname dummy0 con-name dummy0 2>/dev/null

# Ensure it begins in a neutral IPv4 state (auto, no static config, no autoconnect).
nmcli connection modify dummy0 \
  ipv4.method auto \
  ipv4.addresses "" \
  ipv4.gateway "" \
  ipv4.dns "" \
  connection.autoconnect no 2>/dev/null

exit 0
