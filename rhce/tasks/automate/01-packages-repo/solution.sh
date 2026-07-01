#!/usr/bin/env bash
cd /root/rhce/packages-repo
cat > playbook.yml <<'PB'
---
- name: Configure repo and install tree
  hosts: managed
  become: true
  tasks:
    - name: Define the localdvd repository
      ansible.builtin.yum_repository:
        name: localdvd
        description: Local DVD BaseOS
        baseurl: file:///mnt/dvd/BaseOS
        gpgcheck: false
        enabled: true

    - name: Ensure tree is installed
      ansible.builtin.package:
        name: tree
        state: present
PB
ansible-playbook playbook.yml
