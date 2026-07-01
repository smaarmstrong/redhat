#!/usr/bin/env bash
cd /root/rhce/loops
cat > playbook.yml <<'PB'
---
- name: Create application users with a loop
  hosts: managed
  become: true
  tasks:
    - name: Ensure the app users exist
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop:
        - app1
        - app2
        - app3
PB
ansible-playbook playbook.yml
