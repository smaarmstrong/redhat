#!/usr/bin/env bash
cd /root/rhce/galaxy-install
cat > requirements.yml <<'REQ'
---
roles:
  - name: geerlingguy.ntp
REQ
ansible-galaxy role install -r requirements.yml -p roles
