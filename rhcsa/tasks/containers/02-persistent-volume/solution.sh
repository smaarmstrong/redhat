#!/usr/bin/env bash
# Reference solution (named-volume approach).
img=registry.access.redhat.com/ubi9/ubi
podman image exists "$img" || img=docker.io/library/alpine
podman rm -f datastore 2>/dev/null
podman volume create appdata 2>/dev/null || true
podman run -d --name datastore -v appdata:/data "$img" sleep infinity
