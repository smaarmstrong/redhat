#!/usr/bin/env bash
cd /opt/rhce/static-inventory
cat > inventory <<'INV'
[webservers]
node1.example.com
node2.example.com

[dbservers]
node3.example.com

[production:children]
webservers
dbservers
INV
