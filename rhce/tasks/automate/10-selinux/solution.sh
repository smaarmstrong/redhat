#!/usr/bin/env bash
cd /root/rhce/selinux
cat > playbook.yml <<'PB'
---
- name: Enable an SELinux boolean persistently
  hosts: managed
  become: true
  tasks:
    - name: Allow httpd to make network connections
      ansible.posix.seboolean:
        name: httpd_can_network_connect
        state: true
        persistent: true
PB
ansible-playbook playbook.yml
