#!/usr/bin/env bash
command -v ansible >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true

d=/root/rhce/adhoc-script
mkdir -p "$d"; rm -f "$d/check.sh"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
exit 0
