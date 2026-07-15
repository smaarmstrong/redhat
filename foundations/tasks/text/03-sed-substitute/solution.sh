#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
sed -i 's/^mode=debug$/mode=production/' /opt/found/conflab/app.conf
sed -i 's#http://#https://#g'            /opt/found/conflab/app.conf
sed -i '/^loglevel=verbose$/d'           /opt/found/conflab/app.conf
exit 0
