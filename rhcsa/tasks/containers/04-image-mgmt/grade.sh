#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

if ! command -v podman >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} podman is not installed — this bonus task needs container-tools\n"
  check_eval "podman is available" 'false'
  grade_summary
  exit $?
fi

check_eval "image 'localhost/myapp:v1' exists" 'podman image exists localhost/myapp:v1'

grade_summary
