#!/usr/bin/env bash
cd /opt/rhce/cron
cat > playbook.yml <<'PB'
---
- name: Schedule nightly backup cron job
  hosts: managed
  become: true
  tasks:
    - name: Create nightly-backup cron job for root
      ansible.builtin.cron:
        name: nightly-backup
        user: root
        minute: "15"
        hour: "2"
        day: "*"
        month: "*"
        weekday: "*"
        job: /usr/local/bin/backup.sh
        state: present
PB
ansible-playbook playbook.yml
