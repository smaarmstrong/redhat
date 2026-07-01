#!/usr/bin/env bash
cd /root/rhce/vault
# create the plaintext then encrypt it in place with the provided password file
cat > secret.yml <<'VARS'
db_password: s3cret
VARS
ansible-vault encrypt --vault-password-file vaultpass secret.yml
cat > playbook.yml <<'PB'
---
- name: Use a vaulted variable
  hosts: managed
  gather_facts: false
  vars_files:
    - secret.yml
  tasks:
    - name: Write the decrypted secret to a file
      ansible.builtin.copy:
        content: "{{ db_password }}"
        dest: /root/rhce/vault/out.txt
        mode: '0600'
PB
ansible-playbook --vault-password-file vaultpass playbook.yml
