#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true

# clean prior state: blank the motd so the task starts from a known state
: > /etc/motd 2>/dev/null || true

d=/opt/rhce/deploy-file
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
