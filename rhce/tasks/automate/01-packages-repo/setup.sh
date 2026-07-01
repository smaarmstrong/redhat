#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
dnf -y remove tree >/dev/null 2>&1 || true
rm -f /etc/yum.repos.d/localdvd.repo 2>/dev/null || true
d=/root/rhce/packages-repo
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
