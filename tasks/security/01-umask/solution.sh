#!/usr/bin/env bash
# Reference solution: a login-shell drop-in that sets the default umask.
echo 'umask 077' > /etc/profile.d/umask.sh
chmod 0644 /etc/profile.d/umask.sh
