#!/usr/bin/env bash
# Clean slate + best-effort prerequisites. Idempotent.
command -v podman >/dev/null 2>&1 || dnf -y install container-tools 2>/dev/null || true

# Remove the target tag from a previous attempt (leave base images cached).
podman rmi localhost/myapp:v1 2>/dev/null || true

# Best-effort pre-pull a tiny image so the tag step is doable offline once cached.
podman pull registry.access.redhat.com/ubi9/ubi 2>/dev/null \
  || podman pull docker.io/library/alpine 2>/dev/null \
  || true

exit 0
