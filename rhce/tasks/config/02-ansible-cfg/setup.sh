#!/usr/bin/env bash
command -v ansible-config >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/ansible-cfg
mkdir -p "$d"; rm -f "$d/ansible.cfg"
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
