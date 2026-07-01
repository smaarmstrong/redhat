#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
# best-effort: ensure firewalld installed + running, and the ansible.posix collection
rpm -q firewalld >/dev/null 2>&1 || dnf -y install firewalld >/dev/null 2>&1 || true
systemctl enable --now firewalld >/dev/null 2>&1 || true
if command -v ansible-galaxy >/dev/null; then
  ansible-galaxy collection list 2>/dev/null | grep -q 'ansible.posix' || \
    ansible-galaxy collection install ansible.posix >/dev/null 2>&1 || true
fi
# undo the target state: remove http so there is work to do
firewall-cmd --permanent --remove-service=http >/dev/null 2>&1 || true
firewall-cmd --remove-service=http >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null 2>&1 || true
d=/root/rhce/firewall
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
