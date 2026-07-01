#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

if ! command -v chronyd >/dev/null 2>&1; then
  printf "  ${C_Y}note${C_0} chrony is not installed and no repo was available to install it.\n"
fi

# The server line may live in /etc/chrony.conf or any drop-in under /etc/chrony.d.
# Match: server time.cloudflare.com ... (iburst optional in the regex; the
# prompt asks for iburst but we grade the essential 'server <host>' directive).
has_server_line() {
  { cat /etc/chrony.conf /etc/chrony.d/*.conf; } 2>/dev/null \
    | grep -Eq '^[[:space:]]*server[[:space:]]+time\.cloudflare\.com([[:space:]]|$)'
}

check_eval "chrony config points at time.cloudflare.com" 'has_server_line'
check_eval "chronyd is enabled (persists across reboot)" 'systemctl is-enabled chronyd'
check_eval "chronyd is active now"                        'systemctl is-active chronyd'

grade_summary
