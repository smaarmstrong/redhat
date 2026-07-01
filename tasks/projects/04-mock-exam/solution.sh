#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"
set -e

# (a) user in wheel.
useradd examuser
usermod -aG wheel examuser

# (b) 256 MiB swap on the spare disk, persistent by UUID.
d="$(spare_disk)"
parted -s "$d" mklabel gpt
parted -s "$d" mkpart primary linux-swap 1MiB 257MiB
partprobe "$d"
sleep 1
part="/dev/$(lsblk -rno NAME "$d" | sed -n 2p)"
mkswap "$part"
swapon "$part"
uuid="$(blkid -s UUID -o value "$part")"
sed -i "\%UUID=$uuid%d" /etc/fstab
printf 'UUID=%s  none  swap  defaults  0 0\n' "$uuid" >> /etc/fstab
systemctl daemon-reload
swapon -a

# (c) chronyd enabled + running.
systemctl enable --now chronyd

# (d) firewalld: 8080/tcp permanently.
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload

# (e) default target.
systemctl set-default multi-user.target

# (f) SELinux enforcing now and on boot.
setenforce 1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# (g) root cron at 06:00 daily.
( crontab -l 2>/dev/null | grep -v '/usr/local/bin/report.sh'
  echo "0 6 * * * /usr/local/bin/report.sh"
) | crontab -

# (h) sticky world-writable shared dir.
mkdir -p /opt/shared
chmod 1777 /opt/shared
