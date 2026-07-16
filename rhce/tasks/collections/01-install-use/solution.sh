#!/usr/bin/env bash
cd /opt/rhce/collection-use
mkdir -p collections
cat > collections/requirements.yml <<'REQ'
---
collections:
  - name: community.general
REQ
ansible-galaxy collection install -r collections/requirements.yml -p collections
cat > playbook.yml <<'PB'
---
- name: Use a module from community.general
  hosts: managed
  become: true
  tasks:
    - name: Write an INI setting
      community.general.ini_file:
        path: /etc/myapp.ini
        section: main
        option: enabled
        value: "true"
        mode: '0644'
PB
ansible-playbook playbook.yml
