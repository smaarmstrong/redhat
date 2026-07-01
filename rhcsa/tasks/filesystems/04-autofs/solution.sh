#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

# Ensure autofs is present.
command -v automount >/dev/null 2>&1 || rpm -q autofs >/dev/null 2>&1 || dnf -y install autofs

# Indirect map: /mnt/auto is the mount root, keys resolved from /etc/auto.share.
# Use a drop-in so we do not disturb the packaged /etc/auto.master.
mkdir -p /etc/auto.master.d
printf '/mnt/auto\t/etc/auto.share\n' > /etc/auto.master.d/share.autofs

# Map entry: the key "share" mounts localhost:/srv/share over NFS.
printf 'share\t-fstype=nfs\tlocalhost:/srv/share\n' > /etc/auto.share

systemctl enable --now autofs
systemctl reload autofs 2>/dev/null || systemctl restart autofs

# Trigger it once to demonstrate.
ls /mnt/auto/share >/dev/null 2>&1 || true
