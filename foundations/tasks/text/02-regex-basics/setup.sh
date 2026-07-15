#!/usr/bin/env bash
# Clean slate: a fixed inventory file with near-miss lines that only a
# correct regex separates, in a world-writable practice dir.
rm -rf /opt/found/regexlab
mkdir -p /opt/found
install -d -m 0777 /opt/found/regexlab
cat > /opt/found/regexlab/inventory.txt <<'DATA'
# stock list, updated nightly
AB-1002 copper wire roll 4.50
tape measure old-stock 3.99
# prices include VAT
ZX-9014 angle grinder 89.00
hammer classic 12
CD-77 short code, not valid
socket set metric 25.50
QQ-1234 spare fuses 1.05
note: reorder level is 10 units
DATA
chmod 0644 /opt/found/regexlab/inventory.txt
exit 0
