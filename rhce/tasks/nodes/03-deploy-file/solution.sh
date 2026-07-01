#!/usr/bin/env bash
cd /root/rhce/deploy-file
cat > playbook.yml <<'PB'
---
- name: Deploy /etc/motd to managed nodes
  hosts: managed
  become: true
  tasks:
    - name: Create /etc/motd
      ansible.builtin.copy:
        dest: /etc/motd
        content: "Managed by Ansible\n"
        owner: root
        group: root
        mode: '0644'
PB
ansible-playbook playbook.yml
