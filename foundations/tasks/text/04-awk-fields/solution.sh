#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
awk -F: '{print $1}'          /opt/found/awklab/staff.txt > /opt/found/awklab/names.txt
awk -F: '{print $1, $3}'      /opt/found/awklab/staff.txt > /opt/found/awklab/locations.txt
awk -F: '$2 == "Engineering"' /opt/found/awklab/staff.txt > /opt/found/awklab/engineering.txt
exit 0
