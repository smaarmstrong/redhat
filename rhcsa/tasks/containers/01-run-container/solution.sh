#!/usr/bin/env bash
# Reference solution.
img=registry.access.redhat.com/ubi9/ubi
podman image exists "$img" || img=docker.io/library/alpine
podman rm -f web 2>/dev/null
podman run -d --name web -p 8080:80 "$img" sleep infinity
