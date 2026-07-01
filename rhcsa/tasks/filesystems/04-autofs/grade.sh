#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# Grade autofs config for auto-mounting localhost:/srv/share at /mnt/auto/share.

# Note if the tooling is missing — the config checks still run honestly.
if ! rpm -q autofs >/dev/null 2>&1 && ! command -v automount >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} autofs is not installed — install it (dnf install autofs)\n"
fi
if ! systemctl is-active nfs-server >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} nfs-server is not active — the on-access mount may not trigger\n"
fi

# Does any master map (auto.master or a drop-in) reference the /mnt/auto tree?
master_ref="grep -Rhs -- '/mnt/auto' /etc/auto.master /etc/auto.master.d/ 2>/dev/null | grep -v '^[[:space:]]*#' | grep -q '/mnt/auto'"

# Best-effort: touch the key so autofs mounts it, then check it's an NFS mount.
ls /mnt/auto/share >/dev/null 2>&1 || true
triggered_fstype="$(findmnt -no FSTYPE /mnt/auto/share 2>/dev/null)"

check_eval "autofs is installed"                       'rpm -q autofs || command -v automount'
check_eval "autofs is enabled at boot"                 'systemctl is-enabled autofs'
check_eval "autofs is running"                          'systemctl is-active autofs'
check_eval "a master map references /mnt/auto"         "$master_ref"
check_eval "a map entry points at localhost:/srv/share" "grep -Rhs -- 'localhost:/srv/share' /etc/auto.* 2>/dev/null | grep -v '^[[:space:]]*#' | grep -q '/srv/share'"
check_eval "ls /mnt/auto/share triggers an NFS mount"  'case "$triggered_fstype" in nfs|nfs4) true;; *) false;; esac'

grade_summary
