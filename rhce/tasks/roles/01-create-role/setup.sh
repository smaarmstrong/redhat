#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/root/rhce/create-role
mkdir -p "$d/roles"
rm -f "$d/site.yml"
rm -rf "$d/roles/webconfig"
rm -f /etc/myapp/app.conf
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
roles_path = roles
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
exit 0
