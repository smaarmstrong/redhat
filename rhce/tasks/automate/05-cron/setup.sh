#!/usr/bin/env bash
command -v ansible-playbook >/dev/null || dnf -y install ansible-core >/dev/null 2>&1 || true
# undo the target state so there is work to do: clear any existing nightly-backup entry
if crontab -l >/dev/null 2>&1; then
  crontab -l 2>/dev/null | grep -v 'nightly-backup' | grep -v '/usr/local/bin/backup.sh' | crontab - 2>/dev/null || true
fi
d=/opt/rhce/cron
mkdir -p "$d"; rm -f "$d/playbook.yml"
cat > "$d/ansible.cfg" <<'CFG'
[defaults]
inventory = inventory
host_key_checking = False
CFG
cat > "$d/inventory" <<'INV'
[managed]
localhost ansible_connection=local
INV
chown -R "${SUDO_USER:-root}": "$d"
exit 0
