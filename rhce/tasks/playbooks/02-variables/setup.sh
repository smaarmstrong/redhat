#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/variables
mkdir -p "$d"; rm -f "$d/playbook.yml"
# the playbook's target_file lives outside the task dir — make sure the
# parent exists and the learner can write it (the play has no become)
mkdir -p /opt/rhce/vars; rm -f /opt/rhce/vars/hello.txt
chown "${SUDO_USER:-root}": /opt/rhce/vars
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
