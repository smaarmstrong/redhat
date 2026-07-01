#!/usr/bin/env bash
# Establish a clean starting state: exactly one detached CPU-burning process
# running the recognizable script /usr/local/bin/runaway-hog.sh.

# Kill any instance left over from a previous attempt.
pkill -f runaway-hog 2>/dev/null
# Give the kernel a moment to reap them.
for _ in 1 2 3 4 5; do
  pgrep -f runaway-hog >/dev/null 2>&1 || break
  sleep 0.2
done

# (Re)create the hog script.
install -d -m 0755 /usr/local/bin
cat > /usr/local/bin/runaway-hog.sh <<'EOF'
#!/usr/bin/env bash
# A deliberate CPU hog for the "kill a runaway process" drill.
while :; do :; done
EOF
chmod +x /usr/local/bin/runaway-hog.sh

# Launch it fully detached so it survives the setup shell exiting.
setsid bash /usr/local/bin/runaway-hog.sh >/dev/null 2>&1 < /dev/null &

# Confirm exactly one instance is running.
for _ in 1 2 3 4 5; do
  pgrep -f runaway-hog >/dev/null 2>&1 && break
  sleep 0.2
done

exit 0
