#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
command -v chronyd >/dev/null || rpm -q chrony >/dev/null 2>&1 || dnf -y install chrony >/dev/null 2>&1 || true
# undo the target state: disable + stop chronyd so there is work to do
systemctl disable --now chronyd >/dev/null 2>&1 || true
d=/root/rhce/services
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
exit 0
