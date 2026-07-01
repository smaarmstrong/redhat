#!/usr/bin/env bash
# Reference solution: creates the required script.
cat > /usr/local/bin/checkpath.sh <<'EOF'
#!/usr/bin/env bash
if [ -e "$1" ]; then
  echo EXISTS
else
  echo MISSING
fi
EOF
chmod +x /usr/local/bin/checkpath.sh
