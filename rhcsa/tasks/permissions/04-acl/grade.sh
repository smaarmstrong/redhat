#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

check_eval "user 'auditor' exists"                 'getent passwd auditor'
check_eval "/srv/data/ledger.csv exists"           '[ -f /srv/data/ledger.csv ]'
check_eval "owner is still root:root"              '[ "$(stat -c %U:%G /srv/data/ledger.csv 2>/dev/null)" = root:root ]'
check_eval "ACL grants user:auditor read"          'getfacl -p /srv/data/ledger.csv 2>/dev/null | grep -Eq "^user:auditor:r(-|w)-"'
check_eval "'auditor' can read the file"           'sudo -u auditor test -r /srv/data/ledger.csv'
check_eval "'other' still cannot read (not world-readable)" '[ "$(stat -c %A /srv/data/ledger.csv 2>/dev/null | cut -c8)" = "-" ]'

grade_summary
