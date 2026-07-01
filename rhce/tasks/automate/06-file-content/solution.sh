#!/usr/bin/env bash
cd /root/rhce/file-content
cat > playbook.yml <<'PB'
---
- name: Manage limits file content
  hosts: managed
  become: true
  tasks:
    - name: Ensure the nofile soft limit line is present
      ansible.builtin.lineinfile:
        path: /etc/security/limits.d/99-custom.conf
        line: "* soft nofile 4096"
        state: present
        create: true
        mode: '0644'

    - name: Ensure a managed block of custom limits
      ansible.builtin.blockinfile:
        path: /etc/security/limits.d/99-custom.conf
        block: |
          * hard nofile 8192
          * soft nproc 2048
PB
ansible-playbook playbook.yml
