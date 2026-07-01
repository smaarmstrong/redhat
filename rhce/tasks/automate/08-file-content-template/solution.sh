#!/usr/bin/env bash
cd /root/rhce/motd-content
cat > playbook.yml <<'PB'
---
- name: Manage /etc/motd from a content variable
  hosts: managed
  become: true
  vars:
    motd_text: |
      Authorized access only.
      Managed by Ansible.
  tasks:
    - name: Write the message of the day
      ansible.builtin.copy:
        content: "{{ motd_text }}"
        dest: /etc/motd
        owner: root
        group: root
        mode: '0644'
PB
ansible-playbook playbook.yml
