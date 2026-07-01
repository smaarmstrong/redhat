#!/usr/bin/env bash
# Establish a clean starting state: exactly one detached process running
# /usr/local/bin/nicejob.sh at the default nice value (0).

# Remove any instance left over from a previous attempt.
pkill -f nicejob 2>/dev/null
for _ in 1 2 3 4 5; do
  pgrep -f nicejob >/dev/null 2>&1 || break
  sleep 0.2
done

install -d -m 0755 /usr/local/bin
cat > /usr/local/bin/nicejob.sh <<'EOF'
#!/usr/bin/env bash
# A long-lived, low-impact job for the "adjust process scheduling" drill.
while :; do sleep 5; done
EOF
chmod +x /usr/local/bin/nicejob.sh

# Launch it fully detached at the default niceness so it survives setup exiting.
setsid bash /usr/local/bin/nicejob.sh >/dev/null 2>&1 < /dev/null &

for _ in 1 2 3 4 5; do
  pgrep -f nicejob >/dev/null 2>&1 && break
  sleep 0.2
done

exit 0
