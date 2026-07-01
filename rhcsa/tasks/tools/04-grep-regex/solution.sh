#!/usr/bin/env bash
# Reference solution.
grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/access.sample > /root/ips.txt
