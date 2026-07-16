#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true

# managed user
id ansible >/dev/null 2>&1 || useradd -m ansible >/dev/null 2>&1 || true

# clean prior state: remove any existing sudoers drop-in for ansible
rm -f /etc/sudoers.d/ansible /etc/sudoers.d/50-ansible 2>/dev/null || true

d=/opt/rhce/privilege-escalation
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
chown -R "${SUDO_USER:-root}": "$d"
exit 0
