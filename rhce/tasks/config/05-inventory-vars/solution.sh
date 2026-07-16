#!/usr/bin/env bash
cd /opt/rhce/inventory-vars
mkdir -p group_vars
cat > group_vars/webservers <<'GV'
---
http_port: 8080
GV
