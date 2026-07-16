#!/usr/bin/env bash
command -v ansible-galaxy >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/collection-use
mkdir -p "$d/collections"
rm -f "$d/collections/requirements.yml" "$d/playbook.yml"
rm -rf "$d/collections/ansible_collections"
rm -f /etc/myapp.ini
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
collections_path = collections
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
