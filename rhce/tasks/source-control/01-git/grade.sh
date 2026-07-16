#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/git 2>/dev/null || true
command -v git >/dev/null || echo "  ${C_Y}note${C_0} git not installed"
check "work/ directory exists" test -d work
check "work/ is a git repository" bash -c 'git -C work rev-parse --is-inside-work-tree >/dev/null 2>&1'
check "playbook.yml is tracked" bash -c 'git -C work ls-files 2>/dev/null | grep -qx playbook.yml'
check "at least one commit exists" bash -c 'git -C work rev-list --count HEAD 2>/dev/null | grep -Eq "^[1-9][0-9]*$"'
grade_summary
