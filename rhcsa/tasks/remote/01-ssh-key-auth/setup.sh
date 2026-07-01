#!/usr/bin/env bash
# Establish a clean starting state: the deploy user exists with a home and
# shell, sshd is installed and running, and there is no authorized_keys yet.

# openssh-server/clients are in the Rocky 9 base; install best-effort anyway.
rpm -q openssh-server >/dev/null 2>&1 || dnf -y install openssh-server >/dev/null 2>&1

# Create the deploy account (idempotent).
if ! getent passwd deploy >/dev/null 2>&1; then
  useradd -m -s /bin/bash deploy
fi

# Make sure the host keys exist and start the server.
ssh-keygen -A >/dev/null 2>&1
systemctl enable --now sshd >/dev/null 2>&1

# Remove any authorized_keys from a previous attempt so the learner starts fresh.
rm -f /home/deploy/.ssh/authorized_keys 2>/dev/null

exit 0
