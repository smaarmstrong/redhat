#!/usr/bin/env bash
# Best-effort: ensure flatpak is present and the Flathub remote is registered
# so the app can be installed. Remove any prior install of the target app so
# there is work to do. All steps are best-effort and degrade gracefully.
command -v flatpak >/dev/null 2>&1 || dnf -y install flatpak >/dev/null 2>&1 || true
if command -v flatpak >/dev/null 2>&1; then
  flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true
  flatpak uninstall -y org.gnome.Calculator >/dev/null 2>&1 || true
fi
exit 0
