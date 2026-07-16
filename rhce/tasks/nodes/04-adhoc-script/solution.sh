#!/usr/bin/env bash
cd /opt/rhce/adhoc-script
cat > check.sh <<'SH'
#!/usr/bin/env bash
# Validate the managed nodes with an ad-hoc ping. Exits non-zero on failure.
cd "$(dirname "$0")" || exit 1
ansible managed -m ping
SH
chmod +x check.sh
./check.sh
