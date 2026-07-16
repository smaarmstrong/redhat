#!/usr/bin/env bash
cd /opt/rhce/archiving
cat > playbook.yml <<'PB'
---
- name: Archive the SSH configuration
  hosts: managed
  become: true
  tasks:
    - name: Create a gzip archive of /etc/ssh
      community.general.archive:
        path: /etc/ssh
        dest: /opt/rhce/archiving/etc-backup.tar.gz
        format: gz
PB
ansible-playbook playbook.yml
