#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
# The archive module ships in the community.general collection; install best-effort.
command -v ansible-galaxy >/dev/null && ansible-galaxy collection install community.general >/dev/null 2>&1 || true
d=/opt/rhce/archiving
mkdir -p "$d"; rm -f "$d/playbook.yml"
# Undo target end state: remove any prior archive.
rm -f "$d/etc-backup.tar.gz" 2>/dev/null || true
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
