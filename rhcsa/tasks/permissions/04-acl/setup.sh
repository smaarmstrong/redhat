#!/usr/bin/env bash
# Create the 'auditor' user and a root-owned ledger with mode 640.
id auditor >/dev/null 2>&1 || useradd -m auditor

mkdir -p /srv/data
printf 'date,account,amount\n2026-01-01,cash,100.00\n' > /srv/data/ledger.csv

chown root:root /srv/data/ledger.csv
chmod 640 /srv/data/ledger.csv

# Directory must be traversable so the file can be reached.
chmod 755 /srv/data

# Remove any ACL left by a previous attempt so we start clean.
setfacl -b /srv/data/ledger.csv 2>/dev/null
exit 0
