#!/usr/bin/env bash
# Reference solution.
ln    /opt/src/original.txt /opt/src/hardlink.txt
ln -s original.txt          /opt/src/symlink.txt
