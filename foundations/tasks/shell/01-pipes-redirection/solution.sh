#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
sort /opt/found/shop/orders.txt      > /opt/found/shop/sorted.txt
sort -u /opt/found/shop/orders.txt   > /opt/found/shop/unique.txt
wc -l < /opt/found/shop/orders.txt   > /opt/found/shop/count.txt
ls /opt/found/shop/nothing-here     2> /opt/found/shop/errors.txt
exit 0
