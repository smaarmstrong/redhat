#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/mnt/nfs

# If the NFS server never came up, the learner cannot complete this — note it,
# but still grade the end state honestly (checks fail rather than pass).
if ! systemctl is-active nfs-server >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} nfs-server is not active — the export may be unavailable on this host\n"
fi

# The running mount's filesystem type, and the fstab fstype for /mnt/nfs.
mnt_fstype="$(findmnt -no FSTYPE "$MNT" 2>/dev/null)"
fstab_fstype="$(findmnt --fstab -no FSTYPE "$MNT" 2>/dev/null)"

check_eval "/mnt/nfs is mounted"                    'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/mnt/nfs is an NFS mount (nfs/nfs4)"    'case "$mnt_fstype" in nfs|nfs4) true;; *) false;; esac'
check_eval "fstab has an entry for /mnt/nfs"        'findmnt --fstab -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "fstab entry fstype is nfs/nfs4"         'case "$fstab_fstype" in nfs|nfs4) true;; *) false;; esac'
check_eval "fstab source points at an NFS export"  'findmnt --fstab -no SOURCE "$MNT" | grep -q ":/"'

grade_summary
