#!/usr/bin/env bash
# Reference solution (podman generate systemd approach).
img=registry.access.redhat.com/ubi9/ubi
podman image exists "$img" || img=docker.io/library/alpine
podman rm -f svc 2>/dev/null
podman run -d --name svc "$img" sleep infinity

cd /etc/systemd/system
podman generate systemd --name svc --files --new
systemctl daemon-reload
systemctl enable container-svc.service
