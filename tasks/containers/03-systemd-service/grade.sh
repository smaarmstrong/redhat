#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

if ! command -v podman >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} podman is not installed — this bonus task needs container-tools\n"
  check_eval "podman is available" 'false'
  grade_summary
  exit $?
fi

# Pick up any Quadlet-generated units.
systemctl daemon-reload 2>/dev/null || true

# A unit exists for the container: either the generate-systemd naming
# (container-svc.service, installed under /etc/systemd/system) or a Quadlet
# svc.container producing svc.service.
unit_exists() {
  systemctl list-unit-files 2>/dev/null | grep -Eq '^(container-svc|svc)\.service' && return 0
  [ -f /etc/systemd/system/container-svc.service ] && return 0
  [ -f /etc/containers/systemd/svc.container ] && return 0
  return 1
}

# Enabled: is-enabled reports enabled/generated for either candidate unit,
# or a Quadlet .container file carries a [Install] WantedBy=.
unit_enabled() {
  local st
  for u in container-svc.service svc.service; do
    st=$(systemctl is-enabled "$u" 2>/dev/null)
    case "$st" in enabled|generated|static) return 0 ;; esac
  done
  if [ -f /etc/containers/systemd/svc.container ]; then
    grep -Eqi '^\s*WantedBy\s*=' /etc/containers/systemd/svc.container && return 0
  fi
  return 1
}

check_eval "a systemd unit manages container 'svc'" 'unit_exists'
check_eval "that unit is enabled to start at boot"  'unit_enabled'

grade_summary
