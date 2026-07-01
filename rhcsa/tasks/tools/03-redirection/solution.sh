#!/usr/bin/env bash
# Reference solution.
cut -d: -f1 /etc/passwd | sort -u > /root/users.txt
