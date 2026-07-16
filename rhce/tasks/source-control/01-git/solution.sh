#!/usr/bin/env bash
cd /opt/rhce/git
rm -rf work
git clone /opt/rhce/git/origin.git work
cd work
cat > playbook.yml <<'PB'
---
- name: Placeholder play
  hosts: all
  tasks: []
PB
git add playbook.yml
git commit -m "Add playbook"
