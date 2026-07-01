#!/usr/bin/env bash
# Clean slate: firewalld running and enabled, with the cockpit service ALLOWED
# in the default zone (both permanent and runtime) so there is work to do.
systemctl enable --now firewalld 2>/dev/null || systemctl start firewalld 2>/dev/null || true
firewall-cmd --permanent --add-service=cockpit 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true
firewall-cmd --add-service=cockpit 2>/dev/null || true
exit 0
