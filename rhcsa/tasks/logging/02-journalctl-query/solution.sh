#!/usr/bin/env bash
# Reference solution.
journalctl -t rhcsa-drill --no-pager | grep 4711 > /root/drill.txt
