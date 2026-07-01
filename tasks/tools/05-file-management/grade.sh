#!/usr/bin/env bash
. "$(dirname "$(readlink -f "$0")")/../../../games/lib/common.sh"

check_eval "/srv/proj/src is a directory"  '[ -d /srv/proj/src ]'
check_eval "/srv/proj/bin is a directory"  '[ -d /srv/proj/bin ]'
check_eval "/srv/proj/docs is a directory" '[ -d /srv/proj/docs ]'
check_eval "/srv/proj/src/main.sh is a regular file" '[ -f /srv/proj/src/main.sh ]'
check_eval "/srv/proj/docs/hostname.txt is a regular file" '[ -f /srv/proj/docs/hostname.txt ]'
check_eval "hostname.txt content matches /etc/hostname" \
  '[ -f /srv/proj/docs/hostname.txt ] && diff /etc/hostname /srv/proj/docs/hostname.txt'

grade_summary
