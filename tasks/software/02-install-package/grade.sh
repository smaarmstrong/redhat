#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

# 'tree' can only be installed if a working repository (DVD or network) is
# configured. If installation is impossible, tell the learner why rather than
# failing silently.
if ! rpm -q tree >/dev/null 2>&1; then
  if ! dnf -q repolist --enabled 2>/dev/null | grep -q .; then
    printf "  ${C_Y}note${C_0} no enabled dnf repository — configure the DVD/BaseOS repo first (see the software/01 task).\n"
  fi
fi

check "package 'tree' is installed" rpm -q tree

grade_summary
