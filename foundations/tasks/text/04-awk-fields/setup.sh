#!/usr/bin/env bash
# Clean slate: a fixed colon-separated staff file in a world-writable
# practice dir (no sudo needed).
rm -rf /opt/found/awklab
mkdir -p /opt/found
install -d -m 0777 /opt/found/awklab
cat > /opt/found/awklab/staff.txt <<'DATA'
alice:Engineering:London:1200
bob:Sales:Leeds:950
carol:Engineering:Bristol:1400
dave:Support:London:800
erin:Sales:Bristol:1100
frank:Engineering:Leeds:700
DATA
chmod 0644 /opt/found/awklab/staff.txt
exit 0
