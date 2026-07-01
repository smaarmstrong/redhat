#!/usr/bin/env bash
cd /root/rhce/mount
cat > playbook.yml <<'PB'
---
- name: Mount and persist a tmpfs ramdisk
  hosts: managed
  become: true
  tasks:
    - name: Ensure the mount point exists
      ansible.builtin.file:
        path: /mnt/ramdisk
        state: directory
        mode: '0755'

    - name: Mount a tmpfs and persist it in fstab
      ansible.posix.mount:
        path: /mnt/ramdisk
        src: tmpfs
        fstype: tmpfs
        opts: size=64m
        state: mounted
PB
ansible-playbook playbook.yml
