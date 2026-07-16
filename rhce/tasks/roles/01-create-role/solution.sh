#!/usr/bin/env bash
cd /opt/rhce/create-role
mkdir -p roles/webconfig/tasks roles/webconfig/files
cat > roles/webconfig/files/app.conf <<'CONF'
# Managed by the webconfig role
[myapp]
enabled = true
log_level = info
CONF
cat > roles/webconfig/tasks/main.yml <<'TASKS'
---
- name: Ensure config directory exists
  ansible.builtin.file:
    path: /etc/myapp
    state: directory
    mode: '0755'

- name: Deploy app.conf
  ansible.builtin.copy:
    src: app.conf
    dest: /etc/myapp/app.conf
    mode: '0644'
TASKS
cat > site.yml <<'PB'
---
- name: Apply webconfig role
  hosts: managed
  become: true
  roles:
    - webconfig
PB
ansible-playbook site.yml
