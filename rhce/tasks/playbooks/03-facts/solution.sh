#!/usr/bin/env bash
cd /opt/rhce/facts
cat > playbook.yml <<'PB'
---
- name: Render facts into /etc/issue
  hosts: managed
  become: true
  tasks:
    - name: Write host and OS facts
      ansible.builtin.copy:
        dest: /etc/issue
        content: "Host: {{ ansible_hostname }} OS: {{ ansible_distribution }}\n"
PB
ansible-playbook playbook.yml
