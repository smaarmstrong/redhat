#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

if ! command -v podman >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} podman is not installed — this bonus task needs container-tools\n"
  check_eval "podman is available" 'false'
  grade_summary
  exit $?
fi

check_eval "container 'datastore' exists"       'podman container exists datastore'
check_eval "container 'datastore' is running"   '[ "$(podman inspect -f "{{.State.Running}}" datastore 2>/dev/null)" = "true" ]'
check_eval "a volume/mount is present at /data"  'podman inspect -f "{{range .Mounts}}{{.Destination}}{{\"\n\"}}{{end}}" datastore 2>/dev/null | grep -qx "/data"'

grade_summary
