#!/usr/bin/env bash
# Reference solution: creates the required script.
cat > /usr/local/bin/sumargs.sh <<'EOF'
#!/usr/bin/env bash
sum=0
for n in "$@"; do
  sum=$((sum + n))
done
echo "$sum"
EOF
chmod +x /usr/local/bin/sumargs.sh
