#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "runtime mode is Enforcing (getenforce)" \
  '[ "$(getenforce)" = "Enforcing" ]'

check_eval "boot config set to enforcing (/etc/selinux/config)" \
  'grep -Eq "^SELINUX=enforcing[[:space:]]*$" /etc/selinux/config'

grade_summary
