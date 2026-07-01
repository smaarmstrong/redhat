#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
# Idempotent clean start: blank spare disk, no /srv/www mount, no webdev group,
# no leftover fcontext rule. Do NOT disturb the root disk or base system.

MNT=/srv/www

# semanage is optional; best-effort install so the persistent-context step works.
command -v semanage >/dev/null 2>&1 || dnf -y install policycoreutils-python-utils >/dev/null 2>&1 || true

# Unmount our mountpoint if a prior attempt left it mounted.
umount "$MNT" 2>/dev/null

# Tear down our VG if it exists (it lives on the spare).
if vgs vg_web >/dev/null 2>&1; then
  vgchange -an vg_web >/dev/null 2>&1
  vgremove -f vg_web >/dev/null 2>&1
fi

# Remove any fstab line for our mountpoint.
if [ -f /etc/fstab ]; then
  sed -i '\%[[:space:]]'"$MNT"'[[:space:]]%d' /etc/fstab
fi

# Remove any leftover persistent fcontext rule for /srv/www from a prior attempt.
if command -v semanage >/dev/null 2>&1; then
  semanage fcontext -d '/srv/www(/.*)?' 2>/dev/null || true
fi

# Remove the collaborative group so the learner creates it.
groupdel webdev 2>/dev/null

# Wipe the spare (guards root disk / mounted devices).
d="$(spare_disk)" || { echo "no spare disk found"; }
[ -n "$d" ] && wipe_spare "$d"

systemctl daemon-reload 2>/dev/null

# Leave the mountpoint absent so the learner creates it.
rmdir "$MNT" 2>/dev/null

# firewalld should be present and running for the HTTP step to be gradable.
rpm -q firewalld >/dev/null 2>&1 || dnf -y install firewalld >/dev/null 2>&1 || true
systemctl enable --now firewalld >/dev/null 2>&1
# Ensure http is NOT already open, so there is work to do.
firewall-cmd --permanent --remove-service=http >/dev/null 2>&1
firewall-cmd --remove-service=http >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1

exit 0
