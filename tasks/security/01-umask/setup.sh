#!/usr/bin/env bash
# Clean slate: remove any profile.d umask drop-in from a previous attempt so
# the default umask reverts to the system default (typically 022).
rm -f /etc/profile.d/umask.sh 2>/dev/null || true
exit 0
