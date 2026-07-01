#!/usr/bin/env bash
cd /root/rhce/archiving
cat > playbook.yml <<'PB'
---
- name: Archive the SSH configuration
  hosts: managed
  become: true
  tasks:
    - name: Create a gzip archive of /etc/ssh
      community.general.archive:
        path: /etc/ssh
        dest: /root/rhce/archiving/etc-backup.tar.gz
        format: gz
PB
ansible-playbook playbook.yml
