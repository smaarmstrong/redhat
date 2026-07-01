#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"

# The last matching directive in the merged config wins. Prefer sshd's own
# effective view; fall back to grepping the files if that binary path differs.
EFFECTIVE=$(sshd -T 2>/dev/null | awk 'tolower($1)=="passwordauthentication"{print tolower($2)}')

check_eval "sshd config is valid (sshd -t)" 'sshd -t 2>/dev/null'

if [ -n "$EFFECTIVE" ]; then
  check_eval "effective PasswordAuthentication is no" '[ "$EFFECTIVE" = no ]'
else
  # Fallback: no effective query available — grep the files for a "no" that is
  # not overridden by a later "yes".
  check_eval "PasswordAuthentication no is configured" \
    'grep -rhiE "^[[:space:]]*PasswordAuthentication[[:space:]]+no" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/ 2>/dev/null | grep -q .'
  check_eval "no lingering PasswordAuthentication yes" \
    '! grep -rhiE "^[[:space:]]*PasswordAuthentication[[:space:]]+yes" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/ 2>/dev/null | grep -q .'
fi

# Persistence: the setting lives in a config file, not just the running daemon.
check_eval "setting is written to a config file (persists reboot)" \
  'grep -rhiE "^[[:space:]]*PasswordAuthentication[[:space:]]+no" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/ 2>/dev/null | grep -q .'

# Best-effort: sshd was reloaded so the change is live now too.
if systemctl is-active --quiet sshd; then
  check "sshd service is active" systemctl is-active --quiet sshd
else
  echo "  ${C_Y}note${C_0}: sshd is not active — reload it so the change is live."
fi

grade_summary
