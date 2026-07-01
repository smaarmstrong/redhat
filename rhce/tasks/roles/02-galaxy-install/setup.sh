#!/usr/bin/env bash
command -v ansible-galaxy >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/root/rhce/galaxy-install
mkdir -p "$d/roles"
rm -f "$d/requirements.yml"
rm -rf "$d/roles/geerlingguy.ntp"
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
