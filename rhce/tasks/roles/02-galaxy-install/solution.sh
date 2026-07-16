#!/usr/bin/env bash
cd /opt/rhce/galaxy-install
cat > requirements.yml <<'REQ'
---
roles:
  - name: geerlingguy.ntp
REQ
ansible-galaxy role install -r requirements.yml -p roles
