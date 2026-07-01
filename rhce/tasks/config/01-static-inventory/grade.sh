#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/static-inventory 2>/dev/null || true
command -v ansible-inventory >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
inv_has(){ ansible-inventory -i inventory --list 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);sys.exit(0 if sys.argv[2] in d.get(sys.argv[1],{}).get('hosts',[]) else 1)" "$1" "$2"; }
inv_child(){ ansible-inventory -i inventory --list 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);sys.exit(0 if sys.argv[2] in d.get(sys.argv[1],{}).get('children',[]) else 1)" "$1" "$2"; }
check "inventory file exists" test -f inventory
check "inventory parses" bash -c 'ansible-inventory -i inventory --list >/dev/null 2>&1'
check "webservers has node1.example.com" inv_has webservers node1.example.com
check "webservers has node2.example.com" inv_has webservers node2.example.com
check "dbservers has node3.example.com" inv_has dbservers node3.example.com
check "production child: webservers" inv_child production webservers
check "production child: dbservers" inv_child production dbservers
grade_summary
