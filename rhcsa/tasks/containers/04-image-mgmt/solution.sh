#!/usr/bin/env bash
# Reference solution.
img=registry.access.redhat.com/ubi9/ubi
podman pull "$img" 2>/dev/null || { img=docker.io/library/alpine; podman pull "$img"; }
podman tag "$img" localhost/myapp:v1
