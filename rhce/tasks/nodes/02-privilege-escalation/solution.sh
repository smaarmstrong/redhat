#!/usr/bin/env bash
cd /opt/rhce/privilege-escalation
cat > playbook.yml <<'PB'
---
- name: Configure passwordless sudo for the ansible user
  hosts: managed
  become: true
  tasks:
    - name: Deploy a validated sudoers drop-in for ansible
      ansible.builtin.copy:
        dest: /etc/sudoers.d/ansible
        content: "ansible ALL=(ALL) NOPASSWD: ALL\n"
        owner: root
        group: root
        mode: '0440'
        validate: 'visudo -cf %s'
PB
ansible-playbook playbook.yml
