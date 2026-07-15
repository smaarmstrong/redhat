#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
find /opt/found/findlab -name '*.log' | sort > /opt/found/findlab/logfiles.txt
find /opt/found/findlab -name '*.tmp' -delete
mkdir -p /opt/found/findlab/big
# -not -path '*/big/*' skips the destination dir, so we never copy the copy
find /opt/found/findlab -type f -size +1M -not -path '*/big/*' \
     -exec cp {} /opt/found/findlab/big/ \;
exit 0
