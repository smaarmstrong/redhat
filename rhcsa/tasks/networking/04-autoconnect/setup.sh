#!/usr/bin/env bash
# Clean slate: (re)create a dummy connection 'netauto' with autoconnect OFF.
# Changing this profile cannot break the machine's real connectivity.

nmcli connection delete netauto 2>/dev/null

nmcli connection add type dummy ifname netauto0 con-name netauto 2>/dev/null

# Ensure it starts disabled so there is work to do.
nmcli connection modify netauto connection.autoconnect no 2>/dev/null

exit 0
