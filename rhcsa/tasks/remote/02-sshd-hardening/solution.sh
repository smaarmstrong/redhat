#!/usr/bin/env bash
# Reference solution: disable password auth with a drop-in, then reload.
# A high-numbered drop-in wins over the shipped 50-redhat.conf.

cat > /etc/ssh/sshd_config.d/99-no-password.conf <<'EOF'
PasswordAuthentication no
EOF

sshd -t && systemctl reload sshd
