#!/usr/bin/env bash
# Clean slate: the default /etc/motd is empty on Rocky 9. Blank it so a
# previous attempt does not leave the correct content behind.
: > /etc/motd
exit 0
