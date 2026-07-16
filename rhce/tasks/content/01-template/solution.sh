#!/usr/bin/env bash
cd /opt/rhce/template-motd
mkdir -p templates
cat > templates/motd.j2 <<'J2'
Welcome to {{ ansible_hostname }} running {{ ansible_distribution }} {{ ansible_distribution_version }}
J2
cat > playbook.yml <<'PB'
---
- name: Render MOTD from a template
  hosts: managed
  become: true
  gather_facts: true
  tasks:
    - name: Deploy /etc/motd
      ansible.builtin.template:
        src: templates/motd.j2
        dest: /etc/motd
        mode: '0644'
PB
ansible-playbook playbook.yml
