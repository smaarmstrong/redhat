#!/usr/bin/env bash
# Reference solution: grant auditor read via an ACL.
setfacl -m u:auditor:r /srv/data/ledger.csv
