#!/usr/bin/env bash
# Clean slate: a fixed config file with a repeated-match line and a
# "Debug" decoy, in a world-writable practice dir (no sudo needed).
rm -rf /opt/found/conflab
mkdir -p /opt/found
install -d -m 0777 /opt/found/conflab
cat > /opt/found/conflab/app.conf <<'DATA'
# application config
mode=debug
listen=http://0.0.0.0:8080
upstream=http://api.internal:9000
mirrors=http://a.example.com http://b.example.com
loglevel=verbose
banner=Welcome to DebugCo
DATA
chmod 0666 /opt/found/conflab/app.conf
exit 0
