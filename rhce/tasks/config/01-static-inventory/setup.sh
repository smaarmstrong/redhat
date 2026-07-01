#!/usr/bin/env bash
command -v ansible-inventory >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/root/rhce/static-inventory
mkdir -p "$d"; rm -f "$d/inventory"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
exit 0
