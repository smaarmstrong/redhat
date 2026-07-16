#!/usr/bin/env bash
cd /opt/rhce/error-handling
cat > playbook.yml <<'PB'
---
- name: Handle a task failure with block/rescue
  hosts: managed
  become: true
  tasks:
    - name: Try something that fails, then recover
      block:
        - name: This task fails on purpose
          ansible.builtin.command: /bin/false
      rescue:
        - name: Record that we recovered
          ansible.builtin.file:
            path: /opt/rhce/error-handling/recovered.txt
            state: touch
PB
ansible-playbook playbook.yml
