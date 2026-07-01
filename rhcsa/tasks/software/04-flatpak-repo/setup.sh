#!/usr/bin/env bash
# Best-effort: make sure flatpak is available. Then remove any existing
# flathub remote so there is actual work to do. All steps are best-effort so
# the task degrades gracefully when flatpak or the network is unavailable.
command -v flatpak >/dev/null 2>&1 || dnf -y install flatpak >/dev/null 2>&1 || true
if command -v flatpak >/dev/null 2>&1; then
  flatpak remote-delete --force flathub >/dev/null 2>&1 || true
fi
exit 0
