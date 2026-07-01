#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: export /srv/share over NFS to localhost (same as the NFS task),
# best-effort install autofs + nfs-utils, and clear any prior autofs config
# for /mnt/auto so the learner starts clean. No spare disk.

SHARE=/srv/share

# Best-effort install (no internet assumed).
command -v exportfs >/dev/null 2>&1 || dnf -y install nfs-utils 2>/dev/null || true
command -v automount >/dev/null 2>&1 || rpm -q autofs >/dev/null 2>&1 || dnf -y install autofs 2>/dev/null || true

# --- Set up the localhost NFS export ----------------------------------------
mkdir -p "$SHARE"
echo "hello from autofs" > "$SHARE/README"
chmod 0755 "$SHARE"

touch /etc/exports
sed -i '\%^'"$SHARE"'[[:space:]]%d' /etc/exports
printf '%s\t127.0.0.1(rw,sync,no_root_squash)\n' "$SHARE" >> /etc/exports

systemctl enable --now nfs-server 2>/dev/null || true
exportfs -ra 2>/dev/null || true

# --- Clear any prior autofs config for /mnt/auto ----------------------------
# Stop autofs so we can safely tear down mounts/config, then leave it stopped;
# configuring + enabling it is the learner's job.
systemctl stop autofs 2>/dev/null || true

# Make sure nothing is still mounted under /mnt/auto from a prior attempt.
if mountpoint -q /mnt/auto/share 2>/dev/null; then
  umount /mnt/auto/share 2>/dev/null || true
fi

# Remove our master-map entry (direct line in auto.master or a drop-in file).
if [ -f /etc/auto.master ]; then
  sed -i '\%[[:space:]]*/mnt/auto[[:space:]]%d' /etc/auto.master
fi
rm -f /etc/auto.master.d/share.autofs 2>/dev/null
rm -f /etc/auto.share 2>/dev/null
rm -rf /mnt/auto 2>/dev/null

exit 0
