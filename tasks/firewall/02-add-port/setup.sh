#!/usr/bin/env bash
# Clean slate: firewalld running, enabled at boot, and 8080/tcp NOT open.
systemctl enable --now firewalld 2>/dev/null || systemctl start firewalld 2>/dev/null || true
firewall-cmd --permanent --remove-port=8080/tcp 2>/dev/null || true
firewall-cmd --remove-port=8080/tcp 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true
exit 0
