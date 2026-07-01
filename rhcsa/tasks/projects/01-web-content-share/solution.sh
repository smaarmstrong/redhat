#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
set -e

MNT=/srv/www
d="$(spare_disk)"

# 1. LVM stack on the spare disk.
pvcreate -y "$d"
vgcreate vg_web "$d"
lvcreate -y -L 1G -n lv_web vg_web

# 2. XFS + persistent UUID mount at /srv/www.
mkfs.xfs -f /dev/vg_web/lv_web
mkdir -p "$MNT"
uuid="$(blkid -s UUID -o value /dev/vg_web/lv_web)"
sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
printf 'UUID=%s  %s  xfs  defaults  0 0\n' "$uuid" "$MNT" >> /etc/fstab
systemctl daemon-reload
mount -a

# 3. + 4. collaborative setgid directory for webdev.
groupadd -f webdev
chgrp webdev "$MNT"
chmod 2775 "$MNT"

# 5. Persistent SELinux file context, then apply it.
if command -v semanage >/dev/null 2>&1; then
  semanage fcontext -a -t httpd_sys_content_t '/srv/www(/.*)?'
  restorecon -Rv "$MNT"
else
  # Fallback: runtime-only label (will NOT persist a relabel — install
  # policycoreutils-python-utils for the persistent rule).
  chcon -R -t httpd_sys_content_t "$MNT"
fi

# 6. Open HTTP in firewalld, permanently.
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
