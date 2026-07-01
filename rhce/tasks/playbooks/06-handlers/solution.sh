#!/usr/bin/env bash
cd /root/rhce/handlers
cat > playbook.yml <<'PB'
---
- name: Write config and notify a handler
  hosts: managed
  become: true
  tasks:
    - name: Deploy the application config
      ansible.builtin.copy:
        dest: /etc/myapp.conf
        content: "enabled = true\n"
      notify: reload myapp
  handlers:
    - name: reload myapp
      ansible.builtin.file:
        path: /root/rhce/handlers/reloaded.marker
        state: touch
PB
ansible-playbook playbook.yml
