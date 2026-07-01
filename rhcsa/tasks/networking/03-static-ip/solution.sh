#!/usr/bin/env bash
# Reference solution.
nmcli connection modify dummy0 \
  ipv4.method manual \
  ipv4.addresses 10.10.10.5/24 \
  ipv4.gateway 10.10.10.1 \
  ipv4.dns 10.10.10.53 \
  connection.autoconnect yes
