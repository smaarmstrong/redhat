#!/usr/bin/env bash
# Clean slate: reset the postgresql module so no stream is enabled yet.
# Best-effort — if modules/repo are unavailable this is a harmless no-op.
dnf -y module reset postgresql 2>/dev/null || true
exit 0
