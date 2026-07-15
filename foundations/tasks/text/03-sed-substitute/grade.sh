#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

F=/opt/found/conflab/app.conf
expected="$(cat <<'WANT'
# application config
mode=production
listen=https://0.0.0.0:8080
upstream=https://api.internal:9000
mirrors=https://a.example.com https://b.example.com
banner=Welcome to DebugCo
WANT
)"

check_eval "app.conf exists"                       '[ -f $F ]'
check_eval "mode switched to production"           'grep -qx "mode=production" $F'
check_eval "no http:// left anywhere (g flag!)"    '! grep -q "http://" $F'
check_eval "both mirrors rewritten to https"       '[ "$(grep -c "https://" <<<"$(grep mirrors $F)")" -eq 1 ] && grep -q "https://a.example.com https://b.example.com" $F'
check_eval "loglevel line deleted"                 '! grep -q "^loglevel=" $F'
check_eval "banner decoy left untouched"           'grep -qx "banner=Welcome to DebugCo" $F'
check_eval "whole file matches, nothing else changed" '[ "$(cat $F)" = "$expected" ]'

grade_summary
