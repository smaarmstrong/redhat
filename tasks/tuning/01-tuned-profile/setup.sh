#!/usr/bin/env bash
# Start from a clean slate: ensure tuned is present/running and set to balanced.
if ! command -v tuned-adm >/dev/null 2>&1; then
  dnf -y install tuned >/dev/null 2>&1 || true
fi

if command -v tuned-adm >/dev/null 2>&1; then
  systemctl enable --now tuned >/dev/null 2>&1
  tuned-adm profile balanced >/dev/null 2>&1
fi
exit 0
