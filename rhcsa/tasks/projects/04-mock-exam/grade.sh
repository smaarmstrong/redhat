#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

d="$(spare_disk)"

# Locate a swap-formatted partition on the spare disk (for task b).
part=
if [ -n "$d" ]; then
  for p in "$d"[0-9]*; do
    [ -b "$p" ] || continue
    if [ "$(blkid -s TYPE -o value "$p" 2>/dev/null)" = swap ]; then
      part="$p"; break
    fi
  done
fi
uuid="$(blkid -s UUID -o value "$part" 2>/dev/null)"
bytes="$(lsblk -bn -o SIZE "$part" 2>/dev/null | head -1)"
size_mib=$(( ${bytes:-0} / 1048576 ))

# (a) user in wheel ----------------------------------------------------------
check_eval "user 'examuser' exists"              'getent passwd examuser'
check_eval "examuser is a member of wheel"       'id -nG examuser 2>/dev/null | tr " " "\n" | grep -qx wheel'

# (b) 256 MiB persistent swap on the spare -----------------------------------
check_eval "a swap partition exists on the spare disk" '[ -n "$part" ] && [ -b "$part" ]'
check_eval "swap area is ~256 MiB (240-272)"     '[ "$size_mib" -ge 240 ] && [ "$size_mib" -le 272 ]'
check_eval "swap is active now (/proc/swaps)"    '[ -n "$part" ] && grep -q "^$(readlink -f "$part") " /proc/swaps'
check_eval "fstab enables this swap by UUID"     '[ -n "$uuid" ] && grep -Ei "^[[:space:]]*UUID=$uuid[[:space:]]" /etc/fstab | grep -qw swap'

# (c) chronyd ----------------------------------------------------------------
check_eval "chronyd is enabled (persists across reboot)" 'systemctl is-enabled chronyd'
check_eval "chronyd is active now"               'systemctl is-active chronyd'

# (d) firewalld port 8080/tcp -------------------------------------------------
check_eval "firewalld is running"                'systemctl is-active --quiet firewalld'
check_eval "8080/tcp open in permanent config"   'firewall-cmd --permanent --query-port=8080/tcp'
check_eval "8080/tcp open in runtime config"     'firewall-cmd --query-port=8080/tcp'

# (e) default target ----------------------------------------------------------
check_eval "default target is multi-user.target" '[ "$(systemctl get-default 2>/dev/null)" = "multi-user.target" ]'

# (f) SELinux enforcing (runtime + config) -----------------------------------
check_eval "runtime SELinux mode is Enforcing"   '[ "$(getenforce 2>/dev/null)" = "Enforcing" ]'
check_eval "boot config set to enforcing"        'grep -Eq "^SELINUX=enforcing[[:space:]]*$" /etc/selinux/config'

# (g) root cron job at 06:00 daily -------------------------------------------
check_eval "root crontab runs /usr/local/bin/report.sh daily at 06:00" \
  'crontab -l 2>/dev/null | grep -Eq "^[[:space:]]*0{1,2}[[:space:]]+0?6[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+/usr/local/bin/report\.sh"'

# (h) /opt/shared sticky world-writable --------------------------------------
check_eval "/opt/shared exists and is a directory" '[ -d /opt/shared ]'
check_eval "/opt/shared mode is 1777 (sticky + world-writable)" \
  '[ "$(stat -c %a /opt/shared 2>/dev/null)" = 1777 ]'

grade_summary
