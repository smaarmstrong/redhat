#!/usr/bin/env bash
cd /opt/rhce/install-package
cat > playbook.yml <<'PB'
---
- name: Install tree
  hosts: managed
  become: true
  tasks:
    - name: Ensure tree is installed
      ansible.builtin.package:
        name: tree
        state: present
PB
ansible-playbook playbook.yml
