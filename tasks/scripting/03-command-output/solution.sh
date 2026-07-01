#!/usr/bin/env bash
# Reference solution: write the script, then make it executable.
cat > /usr/local/bin/countusers.sh <<'EOF'
#!/usr/bin/env bash
# Capture command output within the script and print only the account count.
count=$(getent passwd | wc -l)
echo "$count"
EOF
chmod +x /usr/local/bin/countusers.sh
