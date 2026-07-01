#!/usr/bin/env bash
# Reference solution.
cat > /etc/yum.repos.d/local.repo <<'EOF'
[localdvd]
name=Local DVD BaseOS
baseurl=file:///mnt/dvd/BaseOS
enabled=1
gpgcheck=0
EOF
