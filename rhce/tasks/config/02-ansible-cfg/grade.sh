#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/ansible-cfg 2>/dev/null || true
command -v ansible-config >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
# cfg_has KEY VALUE : true if `ansible-config dump --only-changed` reports KEY set to VALUE
cfg_has(){ ansible-config dump --only-changed 2>/dev/null | grep -Eiq "^${1}\b.*= *${2}\b"; }
# ini_has SECTION KEY VALUE : fallback plain-file parse of the ini section/key/value
ini_has(){ python3 - "$1" "$2" "$3" <<'PY'
import configparser,sys
s,k,v=sys.argv[1],sys.argv[2],sys.argv[3]
c=configparser.ConfigParser()
try: c.read('ansible.cfg')
except Exception: sys.exit(1)
if not c.has_option(s,k): sys.exit(1)
got=c.get(s,k).strip().lower()
sys.exit(0 if got==v.strip().lower() else 1)
PY
}
check "ansible.cfg exists" test -f ansible.cfg
check_eval "defaults.inventory = inventory" 'cfg_has DEFAULT_HOST_LIST inventory || ini_has defaults inventory inventory'
check_eval "defaults.remote_user = ansible" 'cfg_has DEFAULT_REMOTE_USER ansible || ini_has defaults remote_user ansible'
check_eval "privilege_escalation.become = True" 'cfg_has DEFAULT_BECOME True || ini_has privilege_escalation become True'
check_eval "privilege_escalation.become_method = sudo" 'cfg_has DEFAULT_BECOME_METHOD sudo || ini_has privilege_escalation become_method sudo'
check_eval "privilege_escalation.become_user = root" 'cfg_has DEFAULT_BECOME_USER root || ini_has privilege_escalation become_user root'
grade_summary
