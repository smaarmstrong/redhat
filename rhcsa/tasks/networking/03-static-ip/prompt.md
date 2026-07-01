A NetworkManager connection profile named `dummy0` already exists (it is
attached to a safe dummy interface — configuring it will NOT affect the
machine's real network).

Configure the `dummy0` connection with a STATIC IPv4 setup:

  • Method:      manual
  • Address:     10.10.10.5/24
  • Gateway:     10.10.10.1
  • DNS server:  10.10.10.53
  • Autoconnect: yes (start automatically at boot)

The settings must persist across a reboot. Configure the connection
profile (e.g. with `nmcli connection modify`); do not just set a
live-only address.
