#!/usr/bin/env bash
# Reference solution.
echo "server time.cloudflare.com iburst" >> /etc/chrony.conf
systemctl enable --now chronyd
