#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true

# managed user
id ansible >/dev/null 2>&1 || useradd -m ansible >/dev/null 2>&1 || true

# ensure sshd is up so localhost SSH is gradeable
systemctl enable --now sshd >/dev/null 2>&1 || true

# the control user is whoever invoked this via sudo (root in the selftest container)
U="${SUDO_USER:-root}"
H="$(getent passwd "$U" | cut -d: -f6)"

# clean prior state: remove any existing control-side key and the ansible user's
# authorized_keys so the task starts from scratch
rm -f "$H/.ssh/id_rsa" "$H/.ssh/id_rsa.pub" "$H/.ssh/id_ed25519" "$H/.ssh/id_ed25519.pub" 2>/dev/null || true
rm -f /home/ansible/.ssh/authorized_keys 2>/dev/null || true

d=/opt/rhce/ssh-keys
mkdir -p "$d"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
127.0.0.1 ansible_user=ansible
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
