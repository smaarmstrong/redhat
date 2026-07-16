#!/usr/bin/env bash
cd /opt/rhce/services
cat > playbook.yml <<'PB'
---
- name: Enable and start chronyd
  hosts: managed
  become: true
  tasks:
    - name: Ensure chronyd is enabled and running
      ansible.builtin.service:
        name: chronyd
        enabled: true
        state: started
PB
ansible-playbook playbook.yml
