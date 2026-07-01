#!/usr/bin/env bash
# Idempotent clean start: no nadia account, no engineering group, no sudoers
# drop-in, sshd running with host keys. Do not disturb root's own SSH setup
# beyond ensuring a key exists is the LEARNER's job, so leave root's keys alone.

# openssh-server is in the Rocky 9 base; ensure present + running so key auth
# is testable at grade time.
rpm -q openssh-server >/dev/null 2>&1 || dnf -y install openssh-server >/dev/null 2>&1 || true
ssh-keygen -A >/dev/null 2>&1
systemctl enable --now sshd >/dev/null 2>&1

# Remove the user (and home) and group from any prior attempt.
userdel -r nadia 2>/dev/null
groupdel engineering 2>/dev/null

# Remove any sudoers drop-in a prior attempt created for nadia.
rm -f /etc/sudoers.d/nadia 2>/dev/null

exit 0
