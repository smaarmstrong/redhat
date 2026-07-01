#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
# Idempotent: export /srv/share over NFS to localhost, and leave /mnt/nfs
# unmounted with no fstab entry so the learner can mount it. No spare disk.

MNT=/mnt/nfs
SHARE=/srv/share

# Best-effort install of the NFS packages (no internet assumed).
command -v exportfs >/dev/null 2>&1 || dnf -y install nfs-utils 2>/dev/null || true

# Clean up any prior attempt: unmount and remove our fstab line.
umount "$MNT" 2>/dev/null
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi
systemctl daemon-reload 2>/dev/null
rmdir "$MNT" 2>/dev/null

# Build the export directory with a marker file.
mkdir -p "$SHARE"
echo "hello from nfs" > "$SHARE/README"
chmod 0755 "$SHARE"

# Ensure an export entry for localhost exists exactly once.
touch /etc/exports
sed -i '\%^'"$SHARE"'[[:space:]]%d' /etc/exports
printf '%s\t127.0.0.1(rw,sync,no_root_squash)\n' "$SHARE" >> /etc/exports

# Start the NFS server (best-effort — degrade gracefully if it can't run).
systemctl enable --now nfs-server 2>/dev/null || true
exportfs -ra 2>/dev/null || true

exit 0
