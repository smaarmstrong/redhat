#!/usr/bin/env bash
# Clean slate: a small fixed data file in a world-writable practice dir
# (no sudo needed — this lesson is about redirection, nothing else).
rm -rf /opt/found/shop
mkdir -p /opt/found
install -d -m 0777 /opt/found/shop
cat > /opt/found/shop/orders.txt <<'DATA'
mug
teapot
mug
spoon
kettle
teapot
mug
DATA
chmod 0644 /opt/found/shop/orders.txt
exit 0
