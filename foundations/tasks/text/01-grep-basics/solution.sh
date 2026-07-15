#!/usr/bin/env bash
# Reference solution (the practice dir is world-writable; no sudo needed).
grep -i error   /opt/found/loglab/app.log > /opt/found/loglab/errors.txt
grep -i warning /opt/found/loglab/app.log > /opt/found/loglab/warnings.txt
grep -v DEBUG   /opt/found/loglab/app.log > /opt/found/loglab/nodebug.txt
exit 0
