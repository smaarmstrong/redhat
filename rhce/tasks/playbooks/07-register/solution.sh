#!/usr/bin/env bash
cd /opt/rhce/register
cat > playbook.yml <<'PB'
---
- name: Capture a command result with register
  hosts: managed
  become: true
  tasks:
    - name: Find out who we run as
      ansible.builtin.command: id -un
      register: whoami_result
      changed_when: false

    - name: Save the result to a file
      ansible.builtin.copy:
        dest: /opt/rhce/register/whoami.txt
        content: "{{ whoami_result.stdout }}\n"
PB
ansible-playbook playbook.yml
