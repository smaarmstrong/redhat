#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
# Idempotent clean slate for all eight tasks. Runs INSIDE the throwaway exam VM.

# (a) Remove examuser from a prior attempt.
userdel -r examuser 2>/dev/null

# (b) Clean the spare disk and strip any fstab swap lines that referenced its
#     partitions, without ever touching the base system swap.
d="$(spare_disk)" || echo "no spare disk found"
if [ -n "$d" ]; then
  for part in "$d"[0-9]*; do
    [ -b "$part" ] || continue
    swapoff "$part" 2>/dev/null
    u="$(blkid -s UUID -o value "$part" 2>/dev/null)"
    if [ -n "$u" ] && [ -f /etc/fstab ]; then
      sed -i "\%UUID=$u%d" /etc/fstab
    fi
  done
  wipe_spare "$d"
fi

# (c) chronyd should be installed so it can be enabled; leave it DISABLED/stopped.
rpm -q chrony >/dev/null 2>&1 || dnf -y install chrony >/dev/null 2>&1 || true
systemctl disable --now chronyd >/dev/null 2>&1

# (d) firewalld present + running, but 8080/tcp NOT open yet.
rpm -q firewalld >/dev/null 2>&1 || dnf -y install firewalld >/dev/null 2>&1 || true
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --remove-port=8080/tcp >/dev/null 2>&1
firewall-cmd --remove-port=8080/tcp >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1

# (e) Default target: set to graphical so the learner must switch to multi-user.
systemctl set-default graphical.target >/dev/null 2>&1

# (f) SELinux: put both runtime and config into permissive so there is work to
#     do. (Safe inside the exam VM; never run on a host.)
setenforce 0 >/dev/null 2>&1
if [ -f /etc/selinux/config ]; then
  sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
fi

# (g) Remove any prior report.sh cron line from root's crontab.
if crontab -l >/dev/null 2>&1; then
  crontab -l 2>/dev/null | grep -v '/usr/local/bin/report.sh' | crontab -
fi

# (h) Remove /opt/shared so its mode is graded fresh.
rm -rf /opt/shared 2>/dev/null

systemctl daemon-reload 2>/dev/null
exit 0
