#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
grep -E '[A-Z]{2}-[0-9]{4}'   /opt/found/regexlab/inventory.txt > /opt/found/regexlab/codes.txt
grep    '^#'                  /opt/found/regexlab/inventory.txt > /opt/found/regexlab/comments.txt
grep -E '[0-9]+\.[0-9]{2}$'   /opt/found/regexlab/inventory.txt > /opt/found/regexlab/prices.txt
exit 0
