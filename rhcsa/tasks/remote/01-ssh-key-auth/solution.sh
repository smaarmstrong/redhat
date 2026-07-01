#!/usr/bin/env bash
# Reference solution: generate a key for root if needed, then install root's
# public key for deploy with correct ownership and permissions.

[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa

install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
cat /root/.ssh/id_rsa.pub >> /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys

# ssh-copy-id deploy@localhost would do the same thing interactively.
