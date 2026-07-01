#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/app

# Extend the LV to 512 MiB and grow the mounted XFS filesystem in one step.
lvextend -L 512M /dev/vg_app/lv_app
xfs_growfs "$MNT"

# (xfs_growfs -d "$MNT" also works. lvextend -r -L 512M would combine both.)
