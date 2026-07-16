#!/usr/bin/env bash
cd /opt/rhce/navigator
cat > ansible-navigator.yml <<'YML'
---
ansible-navigator:
  mode: stdout
  playbook-artifact:
    enable: false
YML
