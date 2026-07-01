#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/root/rhce/loops
mkdir -p "$d"; rm -f "$d/playbook.yml"
for u in app1 app2 app3; do userdel -r "$u" >/dev/null 2>&1 || true; done
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
