#!/usr/bin/env bash
cd /root/rhce/navigator
cat > ansible-navigator.yml <<'YML'
---
ansible-navigator:
  mode: stdout
  playbook-artifact:
    enable: false
YML
