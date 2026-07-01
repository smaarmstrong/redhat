#!/usr/bin/env bash
# Start from a clean slate: remove the account if a previous attempt left it.
userdel -r dbuser 2>/dev/null
exit 0
