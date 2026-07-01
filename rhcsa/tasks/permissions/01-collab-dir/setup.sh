#!/usr/bin/env bash
# Clean starting state: no group, no directory.
rm -rf /srv/devshare
groupdel developers 2>/dev/null
exit 0
