#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "runtime mode is Enforcing (getenforce)" \
  '[ "$(getenforce)" = "Enforcing" ]'

check_eval "boot config set to enforcing (/etc/selinux/config)" \
  'grep -Eq "^SELINUX=enforcing[[:space:]]*$" /etc/selinux/config'

grade_summary
