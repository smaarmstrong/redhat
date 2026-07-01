#!/usr/bin/env bash
# Establish a clean starting state: sshd installed and running, and password
# authentication currently ENABLED (the default) so the learner must change it.

rpm -q openssh-server >/dev/null 2>&1 || dnf -y install openssh-server >/dev/null 2>&1
ssh-keygen -A >/dev/null 2>&1

# Remove any drop-in from a previous attempt that might disable passwords.
rm -f /etc/ssh/sshd_config.d/*passwo* /etc/ssh/sshd_config.d/99-no-password.conf 2>/dev/null

# Rocky 9 ships a drop-in (50-redhat.conf) that may set PasswordAuthentication.
# Normalise anything explicit back to "yes" in the main file and any drop-ins.
for f in /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf; do
  [ -f "$f" ] || continue
  sed -ri 's/^[[:space:]]*#?[[:space:]]*PasswordAuthentication[[:space:]].*/PasswordAuthentication yes/I' "$f"
done

# Guarantee at least one explicit "yes" so the starting state is unambiguous.
if ! grep -rqiE '^[[:space:]]*PasswordAuthentication[[:space:]]+yes' \
      /etc/ssh/sshd_config /etc/ssh/sshd_config.d/ 2>/dev/null; then
  echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
fi

systemctl enable --now sshd >/dev/null 2>&1
systemctl reload sshd >/dev/null 2>&1

exit 0
