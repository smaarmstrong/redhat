#!/usr/bin/env bash
. "$(_d="$(dirname "$(readlink -f "$0")")"; while [ ! -e "$_d/games/lib/common.sh" ] && [ "$_d" != / ]; do _d="$(dirname "$_d")"; done; printf %s "$_d/games/lib/common.sh")"
cd /root/rhce/vault 2>/dev/null || true
command -v ansible-playbook >/dev/null || echo "  ${C_Y}note${C_0} ansible-core not installed"
check "vault password file exists" test -f vaultpass
check "secret.yml exists" test -f secret.yml
check_eval "secret.yml is vault-encrypted" 'head -1 secret.yml | grep -q "^\$ANSIBLE_VAULT"'
check "playbook.yml exists" test -f playbook.yml
check "playbook syntax is valid" bash -c 'ansible-playbook --syntax-check --vault-password-file vaultpass playbook.yml >/dev/null 2>&1'
check "playbook runs with vault password" bash -c 'ansible-playbook --vault-password-file vaultpass playbook.yml >/dev/null 2>&1'
check "out.txt exists" test -f out.txt
check_eval "out.txt contains the secret (s3cret)" 'grep -q "s3cret" out.txt'
grade_summary
