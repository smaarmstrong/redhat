A NetworkManager connection profile named `netauto` already exists (it is
attached to a safe dummy interface, so changing it will NOT affect the
machine's real network). Right now it is set NOT to start at boot.

Configure the `netauto` connection so that it connects **automatically at
boot** (autoconnect = yes).

The change must persist across a reboot (modify the connection profile, e.g.
with `nmcli connection modify`).
