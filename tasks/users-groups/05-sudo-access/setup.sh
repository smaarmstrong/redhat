#!/usr/bin/env bash
# Clean start: remove opsadmin and any sudoers.d file from a prior attempt.
userdel -r opsadmin 2>/dev/null
rm -f /etc/sudoers.d/opsadmin 2>/dev/null
exit 0
