#!/usr/bin/env bash
cd /root/rhce/ssh-keys

# 1. Generate a key for root if none exists
[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa

# 2. Distribute it to ansible@127.0.0.1. Two equivalent approaches shown; the
#    playbook one degrades gracefully if ssh-copy-id needs a password.

# --- approach A: ssh-copy-id ---
# ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub ansible@127.0.0.1

# --- approach B: authorized_key module against the local box (no password needed) ---
cat > distribute.yml <<'PB'
---
- name: Distribute root's public key to the ansible user
  hosts: localhost
  connection: local
  become: true
  tasks:
    - name: Read root's public key
      ansible.builtin.slurp:
        src: /root/.ssh/id_rsa.pub
      register: rootkey

    - name: Authorise root's key for the ansible user
      ansible.posix.authorized_key:
        user: ansible
        state: present
        key: "{{ rootkey.content | b64decode }}"
PB
ansible-playbook distribute.yml || {
  # fallback without the posix collection: place the key manually
  install -d -m 700 -o ansible -g ansible /home/ansible/.ssh
  cat /root/.ssh/id_rsa.pub >> /home/ansible/.ssh/authorized_keys
  chmod 600 /home/ansible/.ssh/authorized_keys
  chown ansible:ansible /home/ansible/.ssh/authorized_keys
}
