#!/usr/bin/env bash
# Reference solution.
set -e

# 1. Group with fixed GID, then the user in it.
groupadd -g 5000 engineering
useradd -m -c "Nadia Ops" -s /bin/bash -G engineering nadia

# 2. Full sudo via a validated drop-in file.
echo 'nadia ALL=(ALL) ALL' > /etc/sudoers.d/nadia
chmod 0440 /etc/sudoers.d/nadia
visudo -cf /etc/sudoers.d/nadia

# 3. Password aging: max 90, min 1, warn 14.
chage -M 90 -m 1 -W 14 nadia

# 4. Key-based SSH so root -> nadia@localhost is passwordless.
[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
install -d -m 700 -o nadia -g nadia /home/nadia/.ssh
cat /root/.ssh/id_rsa.pub >> /home/nadia/.ssh/authorized_keys
chmod 600 /home/nadia/.ssh/authorized_keys
chown nadia:nadia /home/nadia/.ssh/authorized_keys
ssh-keygen -A >/dev/null 2>&1
systemctl enable --now sshd

# 5. Collaborative project directory.
mkdir -p /home/nadia/reports
chown nadia:engineering /home/nadia/reports
chmod 2770 /home/nadia/reports
