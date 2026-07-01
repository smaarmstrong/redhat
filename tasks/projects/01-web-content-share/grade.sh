#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

MNT=/srv/www
LV=/dev/vg_web/lv_web

# Resolve LV path/size and the mounted filesystem UUID (best effort; guarded).
lvpath="$(lvs --noheadings -o lv_path vg_web/lv_web 2>/dev/null | tr -d ' ')"
size_mib="$(lvs --noheadings --units m --nosuffix -o lv_size vg_web/lv_web 2>/dev/null | tr -d ' ' | cut -d. -f1)"
uuid="$(findmnt -no UUID "$MNT" 2>/dev/null)"

# --- 1. LVM stack ------------------------------------------------------------
check_eval "volume group vg_web exists"          'vgs vg_web'
check_eval "logical volume lv_web exists"        'lvs vg_web/lv_web'
check_eval "lv_web size is ~1 GiB (1000-1048 MiB)" \
  '[ -n "$size_mib" ] && [ "$size_mib" -ge 1000 ] && [ "$size_mib" -le 1048 ]'

# --- 2. XFS + persistent UUID mount at /srv/www ------------------------------
check_eval "filesystem on lv_web is xfs"         '[ -n "$lvpath" ] && [ "$(blkid -s TYPE -o value "$lvpath")" = xfs ]'
check_eval "mounted at /srv/www"                 'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/srv/www is backed by lv_web"        '[ -n "$lvpath" ] && [ "$(readlink -f "$(findmnt -no SOURCE "$MNT" 2>/dev/null)")" = "$(readlink -f "$lvpath")" ]'
check_eval "fstab mounts /srv/www by UUID"       'findmnt --fstab -no SOURCE "$MNT" | grep -qi "^UUID="'
check_eval "fstab UUID matches the mounted fs"   '[ -n "$uuid" ] && findmnt --fstab -no SOURCE "$MNT" | grep -qi "^UUID=$uuid$"'

# --- 3. + 4. collaborative setgid dir ----------------------------------------
check_eval "group 'webdev' exists"               'getent group webdev'
check_eval "/srv/www group owner is webdev"      '[ "$(stat -c %G "$MNT" 2>/dev/null)" = webdev ]'
check_eval "/srv/www mode is 2775 (setgid)"      '[ "$(stat -c %a "$MNT" 2>/dev/null)" = 2775 ]'

# --- 5. SELinux file context -------------------------------------------------
# Runtime label must be correct regardless of whether semanage is available.
check_eval "runtime type on /srv/www is httpd_sys_content_t (ls -Zd)" \
  'ls -Zd "$MNT" 2>/dev/null | grep -q ":httpd_sys_content_t:"'

if command -v semanage >/dev/null 2>&1; then
  check_eval "persistent fcontext rule maps /srv/www to httpd_sys_content_t" \
    'semanage fcontext -l 2>/dev/null | grep -E "^/srv/www(\(/\.\*\)\?)?[[:space:]]" | grep -q "httpd_sys_content_t"'
else
  printf "  ${C_Y}note${C_0} semanage absent: cannot verify the PERSISTENT fcontext rule; a chcon-only label will not survive restorecon/reboot\n"
fi

# --- 6. firewalld http service -----------------------------------------------
check_eval "firewalld is running"                'systemctl is-active --quiet firewalld'
check_eval "http allowed in permanent config"    'firewall-cmd --permanent --query-service=http'
check_eval "http allowed in runtime config"      'firewall-cmd --query-service=http'

grade_summary
