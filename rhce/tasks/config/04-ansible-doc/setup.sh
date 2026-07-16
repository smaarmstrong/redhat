#!/usr/bin/env bash
command -v ansible-doc >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/ansible-doc
mkdir -p "$d"; rm -f "$d/answer.txt"
chown -R "${SUDO_USER:-root}": "$d"
exit 0
