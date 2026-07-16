#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
# ansible.posix.seboolean ships in the ansible.posix collection; install best-effort.
command -v ansible-galaxy >/dev/null && ansible-galaxy collection install ansible.posix >/dev/null 2>&1 || true
# Undo target end state: turn the boolean off (persistently) if the tooling is present.
command -v setsebool >/dev/null && setsebool -P httpd_can_network_connect off 2>/dev/null || true
d=/opt/rhce/selinux
mkdir -p "$d"; rm -f "$d/playbook.yml"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
