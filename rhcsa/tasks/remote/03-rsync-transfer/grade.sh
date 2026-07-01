#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "/srv/backup exists"       '[ -d /srv/backup ]'

# The definitive test: a dry-run itemized compare must show no changes needed.
# rsync -ni prints one line per item that would transfer; empty output == mirror.
check_eval "/srv/backup is an exact mirror of /srv/source (rsync reports no diffs)" \
  '[ -d /srv/backup ] && [ -z "$(rsync -anic /srv/source/ /srv/backup/ 2>/dev/null)" ]'

# Spot-check that content and the subdirectory actually made it across.
check_eval "nested file copied into subdir" '[ -f /srv/backup/subdir/gamma.log ]'
check_eval "file permissions preserved (alpha.txt is 640)" \
  '[ "$(stat -c %a /srv/backup/alpha.txt 2>/dev/null)" = 640 ]'

grade_summary
