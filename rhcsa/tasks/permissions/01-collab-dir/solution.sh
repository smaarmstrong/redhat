#!/usr/bin/env bash
# Reference solution.
groupadd developers
mkdir -p /srv/devshare
chgrp developers /srv/devshare
chmod 2770 /srv/devshare
