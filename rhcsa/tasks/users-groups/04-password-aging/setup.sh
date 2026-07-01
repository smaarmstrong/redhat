#!/usr/bin/env bash
# Clean start: recreate appuser with default (non-target) aging values so the
# task is a real change, not a no-op.
userdel -r appuser 2>/dev/null
useradd -c "Application User" appuser
echo 'appuser:Redhat123' | chpasswd
# Force default-ish aging so it differs from the target (max=99999, min=0, warn=7).
chage -M 99999 -m 0 -W 14 appuser
exit 0
