#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/template-motd
mkdir -p "$d/templates"
rm -f "$d/playbook.yml" "$d/templates/motd.j2"
: > /etc/motd 2>/dev/null || true
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
