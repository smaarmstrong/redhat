#!/usr/bin/env bash
cd /root/rhce/variables
cat > playbook.yml <<'PB'
---
- name: Write a message to a file using variables
  hosts: managed
  vars:
    target_file: /root/rhce/vars/hello.txt
    message: "hello from ansible"
  tasks:
    - name: Ensure the file has the message
      ansible.builtin.copy:
        dest: "{{ target_file }}"
        content: "{{ message }}\n"
PB
ansible-playbook playbook.yml
