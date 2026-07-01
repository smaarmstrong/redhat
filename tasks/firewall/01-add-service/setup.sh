#!/usr/bin/env bash
# Clean slate: firewalld running, enabled at boot, and http NOT allowed.
systemctl enable --now firewalld 2>/dev/null || systemctl start firewalld 2>/dev/null || true
firewall-cmd --permanent --remove-service=http 2>/dev/null || true
firewall-cmd --remove-service=http 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true
exit 0
