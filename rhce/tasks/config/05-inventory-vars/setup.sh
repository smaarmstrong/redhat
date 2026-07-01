#!/usr/bin/env bash
command -v ansible-inventory >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/root/rhce/inventory-vars
mkdir -p "$d"
rm -rf "$d/group_vars"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[webservers]
node1.example.com ansible_connection=local
INV
exit 0
