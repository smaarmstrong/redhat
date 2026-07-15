#!/usr/bin/env bash
# Clean slate: a small directory tree with logs, temp files and one
# large file, all in world-writable dirs (no sudo needed).
rm -rf /opt/found/findlab
mkdir -p /opt/found
install -d -m 0777 /opt/found/findlab \
                   /opt/found/findlab/reports \
                   /opt/found/findlab/src \
                   /opt/found/findlab/cache \
                   /opt/found/findlab/data
echo "january report"  > /opt/found/findlab/reports/jan.log
echo "february report" > /opt/found/findlab/reports/feb.log
echo "keep me"         > /opt/found/findlab/reports/notes.txt
echo "print('hi')"     > /opt/found/findlab/src/app.py
echo "app started"     > /opt/found/findlab/src/app.log
echo "scratch"         > /opt/found/findlab/src/x.tmp
echo "scratch"         > /opt/found/findlab/cache/a.tmp
echo "scratch"         > /opt/found/findlab/cache/b.tmp
dd if=/dev/zero of=/opt/found/findlab/data/big.bin bs=1024 count=2048 status=none
dd if=/dev/zero of=/opt/found/findlab/data/small.bin bs=1024 count=10 status=none
chmod 0644 /opt/found/findlab/reports/* /opt/found/findlab/src/* \
           /opt/found/findlab/cache/* /opt/found/findlab/data/*
exit 0
