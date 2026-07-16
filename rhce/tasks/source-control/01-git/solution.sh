#!/usr/bin/env bash
cd /opt/rhce/git
# origin.git belongs to the learner but this script runs as root — tell git
# the ownership mismatch is expected (safe.directory via protected env config)
export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0='*'
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
