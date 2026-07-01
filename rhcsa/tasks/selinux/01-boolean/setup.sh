#!/usr/bin/env bash
# Clean slate: force the boolean OFF (persistently) so there is work to do.
command -v semanage >/dev/null || dnf -y install policycoreutils-python-utils 2>/dev/null || true
setsebool -P httpd_can_network_connect off 2>/dev/null || setsebool httpd_can_network_connect off 2>/dev/null || true
exit 0
