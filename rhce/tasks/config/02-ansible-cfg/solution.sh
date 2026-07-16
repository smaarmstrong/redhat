#!/usr/bin/env bash
cd /opt/rhce/ansible-cfg
cat > ansible.cfg <<'CFG'
[defaults]
inventory = inventory
remote_user = ansible

[privilege_escalation]
become = True
become_method = sudo
become_user = root
CFG
