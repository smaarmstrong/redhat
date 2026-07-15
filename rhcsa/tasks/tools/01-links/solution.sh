#!/usr/bin/env bash
# Reference solution.
# /opt/src is root-owned; as a normal user, prefix each command with sudo.
ln    /opt/src/original.txt /opt/src/hardlink.txt
ln -s original.txt          /opt/src/symlink.txt
