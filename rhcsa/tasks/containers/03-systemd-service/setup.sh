#!/usr/bin/env bash
# Clean slate + best-effort prerequisites. Idempotent.
command -v podman >/dev/null 2>&1 || dnf -y install container-tools 2>/dev/null || true

# Remove leftovers from a previous attempt (units + container).
systemctl disable --now container-svc.service 2>/dev/null || true
systemctl disable --now svc.service 2>/dev/null || true
rm -f /etc/systemd/system/container-svc.service 2>/dev/null || true
rm -f /etc/containers/systemd/svc.container 2>/dev/null || true
systemctl daemon-reload 2>/dev/null || true
podman rm -f svc 2>/dev/null || true

# Best-effort pre-pull a tiny image so the task is doable offline once cached.
podman pull registry.access.redhat.com/ubi9/ubi 2>/dev/null \
  || podman pull docker.io/library/alpine 2>/dev/null \
  || true

exit 0
