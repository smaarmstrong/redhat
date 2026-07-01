#!/usr/bin/env bash
# Reference solution: grant everyone read on the file (least surprising fix).
# The directory is already traversable (755).
chmod 644 /srv/reports/report.txt
