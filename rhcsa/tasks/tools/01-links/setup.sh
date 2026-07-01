#!/usr/bin/env bash
# Clean starting state: fresh source file, no links.
rm -f /opt/src/hardlink.txt /opt/src/symlink.txt
mkdir -p /opt/src
echo "This is the original file." > /opt/src/original.txt
exit 0
