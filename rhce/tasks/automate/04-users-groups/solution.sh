#!/usr/bin/env bash
cd /opt/rhce/users-groups
cat > playbook.yml <<'PB'
---
- name: Create devs group and deploybot user
  hosts: managed
  become: true
  tasks:
    - name: Ensure devs group exists with GID 6000
      ansible.builtin.group:
        name: devs
        gid: 6000
        state: present

    - name: Ensure deploybot user exists in devs
      ansible.builtin.user:
        name: deploybot
        groups: devs
        append: true
        comment: Deployment robot
        state: present
PB
ansible-playbook playbook.yml
