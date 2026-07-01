#!/usr/bin/env bash
# Start from a clean slate: place the target script, remove any prior units.
systemctl disable --now sitecheck.timer 2>/dev/null
rm -f /etc/systemd/system/sitecheck.timer /etc/systemd/system/sitecheck.service

cat > /usr/local/bin/sitecheck.sh <<'EOF'
#!/usr/bin/env bash
# Placeholder maintenance script.
echo "sitecheck ran at $(date)"
EOF
chmod +x /usr/local/bin/sitecheck.sh

systemctl daemon-reload 2>/dev/null
exit 0
