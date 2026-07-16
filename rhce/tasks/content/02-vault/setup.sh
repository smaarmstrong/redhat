#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
d=/opt/rhce/vault
mkdir -p "$d"
rm -f "$d/secret.yml" "$d/playbook.yml" "$d/out.txt"
echo 'vaultpw123' > "$d/vaultpass"
chmod 600 "$d/vaultpass"
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
