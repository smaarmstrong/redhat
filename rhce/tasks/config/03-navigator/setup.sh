#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/navigator
mkdir -p "$d"; rm -f "$d/ansible-navigator.yml"
chown -R "${SUDO_USER:-root}": "$d"
exit 0
