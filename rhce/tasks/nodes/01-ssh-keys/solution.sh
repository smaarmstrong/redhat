#!/usr/bin/env bash
cd /opt/rhce/ssh-keys

# The control user is whoever invoked this via sudo (root in the selftest
# container) — the key pair must belong to THEM, not to root.
U="${SUDO_USER:-root}"
H="$(getent passwd "$U" | cut -d: -f6)"

# 1. Generate a key for the control user if none exists
runuser -u "$U" -- bash -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh; [ -f ~/.ssh/id_rsa ] || ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa"

# 2. Distribute it to ansible@127.0.0.1. Two equivalent approaches shown; the
#    playbook one degrades gracefully if ssh-copy-id needs a password.

# --- approach A: ssh-copy-id (run as the control user) ---
# ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub ansible@127.0.0.1

# --- approach B: authorized_key module against the local box (no password needed) ---
cat > distribute.yml <<PB
---
- name: Distribute the control user's public key to the ansible user
  hosts: localhost
  connection: local
  become: true
  tasks:
    - name: Read the control user's public key
      ansible.builtin.slurp:
        src: $H/.ssh/id_rsa.pub
      register: pubkey

    - name: Authorise the key for the ansible user
      ansible.posix.authorized_key:
        user: ansible
        state: present
        key: "{{ pubkey.content | b64decode }}"
PB
chown "$U": distribute.yml
ansible-playbook distribute.yml || {
  # fallback without the posix collection: place the key manually
  install -d -m 700 -o ansible -g ansible /home/ansible/.ssh
  cat "$H/.ssh/id_rsa.pub" >> /home/ansible/.ssh/authorized_keys
  chmod 600 /home/ansible/.ssh/authorized_keys
  chown ansible:ansible /home/ansible/.ssh/authorized_keys
}
