#!/usr/bin/env bash
cd /root/rhce/git
rm -rf work
git clone /root/rhce/git/origin.git work
cd work
cat > playbook.yml <<'PB'
---
- name: Placeholder play
  hosts: all
  tasks: []
PB
git add playbook.yml
git commit -m "Add playbook"
