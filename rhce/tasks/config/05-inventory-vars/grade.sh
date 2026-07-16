#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /opt/rhce/inventory-vars 2>/dev/null || true
command -v ansible-inventory >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
# host_var_is HOST KEY VALUE : true if ansible-inventory --host reports KEY==VALUE (numeric or string)
host_var_is(){ ansible-inventory -i inventory --host "$1" 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);sys.exit(0 if str(d.get(sys.argv[1]))==sys.argv[2] else 1)" "$2" "$3"; }
check "group_vars/webservers file exists" test -f group_vars/webservers
check "inventory parses" bash -c 'ansible-inventory -i inventory --list >/dev/null 2>&1'
check_eval "http_port resolves to 8080 for node1.example.com" 'host_var_is node1.example.com http_port 8080'
grade_summary
