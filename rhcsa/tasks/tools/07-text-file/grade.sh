#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

expected="$(printf 'Authorized access only.\nContact ops@example.com\n')"

check_eval "/etc/motd exists" '[ -f /etc/motd ]'
check_eval "content is exactly the two required lines" \
  '[ -f /etc/motd ] && [ "$(cat /etc/motd)" = "$expected" ]'

grade_summary
