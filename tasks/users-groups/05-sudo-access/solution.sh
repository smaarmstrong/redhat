#!/usr/bin/env bash
# Reference solution — the wheel-group approach (simplest, persistent).
useradd opsadmin
usermod -aG wheel opsadmin

# Alternative: a validated drop-in file instead of wheel membership:
#   echo 'opsadmin ALL=(ALL) ALL' > /etc/sudoers.d/opsadmin
#   chmod 0440 /etc/sudoers.d/opsadmin
#   visudo -cf /etc/sudoers.d/opsadmin
