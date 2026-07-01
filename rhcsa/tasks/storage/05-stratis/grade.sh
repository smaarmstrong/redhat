#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

MNT=/mnt/stratis

# If stratis tooling / daemon is unavailable, this bonus task can't be done —
# note it, but still grade honestly (checks fail rather than pass hollowly).
if ! command -v stratis >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} stratis CLI not found — install stratisd + stratis-cli\n"
fi
if ! systemctl is-active stratisd >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} stratisd is not running — start it (systemctl enable --now stratisd)\n"
fi

check_eval "stratis pool 'pool1' exists"       'stratis pool list 2>/dev/null | grep -qw pool1'
check_eval "stratis filesystem 'fs1' exists"   'stratis filesystem list pool1 2>/dev/null | grep -qw fs1'
check_eval "mounted at /mnt/stratis"           'findmnt -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "/mnt/stratis is backed by pool1/fs1" 'findmnt -no SOURCE "$MNT" 2>/dev/null | grep -q "stratis/pool1/fs1" || [ "$(readlink -f "$(findmnt -no SOURCE "$MNT" 2>/dev/null)")" = "$(readlink -f /dev/stratis/pool1/fs1 2>/dev/null)" ]'
check_eval "filesystem type is xfs"            '[ "$(findmnt -no FSTYPE "$MNT")" = xfs ]'
check_eval "fstab has an entry for /mnt/stratis" 'findmnt --fstab -no TARGET "$MNT" | grep -qx "$MNT"'
check_eval "fstab entry requires stratisd.service" 'findmnt --fstab -no OPTIONS "$MNT" 2>/dev/null | grep -q "x-systemd.requires=stratisd.service"'

grade_summary
