#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/navigator 2>/dev/null || true
python3 -c 'import yaml' 2>/dev/null || echo "  ${C_Y}note${C_0} PyYAML not available (ships with ansible-core)"
# nav_val KEYPATH EXPECTED : true if YAML nav config resolves KEYPATH to EXPECTED
nav_val(){ python3 - "$1" "$2" <<'PY'
import sys,yaml
path,expected=sys.argv[1],sys.argv[2]
try:
    with open('ansible-navigator.yml') as f: d=yaml.safe_load(f)
except Exception: sys.exit(1)
cur=d
for k in path.split('.'):
    if not isinstance(cur,dict) or k not in cur: sys.exit(1)
    cur=cur[k]
sys.exit(0 if str(cur).strip().lower()==expected.strip().lower() else 1)
PY
}
check "ansible-navigator.yml exists" test -f ansible-navigator.yml
check_eval "file is valid YAML" 'python3 -c "import yaml;yaml.safe_load(open(\"ansible-navigator.yml\"))"'
check_eval "ansible-navigator.mode = stdout" 'nav_val ansible-navigator.mode stdout'
check_eval "ansible-navigator.playbook-artifact.enable = false" 'nav_val ansible-navigator.playbook-artifact.enable false'
grade_summary
