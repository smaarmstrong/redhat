#!/usr/bin/env bash
cd /root/rhce/conditionals
cat > playbook.yml <<'PB'
---
- name: Install tree only on Rocky
  hosts: managed
  become: true
  tasks:
    - name: Ensure tree is installed on Rocky hosts
      ansible.builtin.package:
        name: tree
        state: present
      when: ansible_distribution == "Rocky"
PB
ansible-playbook playbook.yml
