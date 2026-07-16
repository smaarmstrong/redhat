#!/usr/bin/env bash
cd /opt/rhce/firewall
cat > playbook.yml <<'PB'
---
- name: Allow http through the firewall
  hosts: managed
  become: true
  tasks:
    - name: Permit http service permanently and immediately
      ansible.posix.firewalld:
        service: http
        state: enabled
        permanent: true
        immediate: true
PB
ansible-playbook playbook.yml
