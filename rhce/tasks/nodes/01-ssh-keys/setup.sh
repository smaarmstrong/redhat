#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true

# managed user
id ansible >/dev/null 2>&1 || useradd -m ansible >/dev/null 2>&1 || true

# ensure sshd is up so localhost SSH is gradeable
systemctl enable --now sshd >/dev/null 2>&1 || true

# clean prior state: remove any existing control-side key and the ansible user's
# authorized_keys so the task starts from scratch
rm -f /root/.ssh/id_rsa /root/.ssh/id_rsa.pub /root/.ssh/id_ed25519 /root/.ssh/id_ed25519.pub 2>/dev/null || true
rm -f /home/ansible/.ssh/authorized_keys 2>/dev/null || true

d=/root/rhce/ssh-keys
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
exit 0
