#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

if ! command -v podman >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} podman is not installed — this bonus task needs container-tools\n"
  check_eval "podman is available" 'false'
  grade_summary
  exit $?
fi

check_eval "container 'web' exists"        'podman container exists web'
check_eval "container 'web' is running"    '[ "$(podman inspect -f "{{.State.Running}}" web 2>/dev/null)" = "true" ]'
check_eval "host port 8080 is published"   'podman port web 2>/dev/null | grep -q "8080"'
check_eval "8080 maps to container port 80" 'podman inspect -f "{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}}={{range \$c}}{{.HostPort}}{{end}} {{end}}" web 2>/dev/null | grep -Eq "80/tcp=8080"'

grade_summary
