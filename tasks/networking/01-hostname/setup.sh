#!/usr/bin/env bash
# Clean slate: revert to a neutral hostname so the task starts fresh.
hostnamectl set-hostname localhost.localdomain 2>/dev/null
exit 0
