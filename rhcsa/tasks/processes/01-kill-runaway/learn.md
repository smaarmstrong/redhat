THE IDEA

  Every running program is a process with a unique number, its PID (process
  ID). When one goes haywire — spinning a CPU core at 100%, leaking memory —
  the fix is two steps: FIND it (get its PID), then KILL it (send it a signal
  that tells it to stop).

  "Kill" sounds violent but really means "send a signal". The default,
  SIGTERM (15), politely asks a process to shut down. SIGKILL (9) is the
  non-negotiable version the kernel enforces for you. You usually try TERM
  first and reach for KILL only if it won't die.

  Right now, thanks to the setup, a runaway process is already burning a core
  — it's running the script /usr/local/bin/runaway-hog.sh. Let's hunt it down.

---

WHY IT MATTERS

  Identifying a CPU or memory hog and stopping it is bread-and-butter
  sysadmin work and a listed exam objective. The skill isn't memorising one
  command — it's the workflow: locate the PID reliably, then signal exactly
  that process (and only that one).

---

STEP 1 — find it

  `top` shows processes sorted by CPU usage live; the hog sits at the top
  around 100%. But for scripting we want just the PID, and `pgrep` gives us
  that. The `-f` flag matches against the FULL command line, not just the
  program name — important here, because the process shows up as `bash
  /usr/local/bin/runaway-hog.sh`, so matching only "bash" would be useless:

```run
pgrep -af runaway-hog
```

  `-a` also prints the command line so you can see what you found. Note the
  PID it reports. You could get the same detail from ps:

```run
ps -ef | grep runaway-hog | grep -v grep
```

---

STEP 2 — kill it

  You can kill by PID with `kill <PID>`, but here we'll use `pkill`, which
  finds and signals in one shot using the same `-f` pattern matching. By
  default it sends SIGTERM:

```run
sudo pkill -f runaway-hog
```

  That's it — one command locates every process whose command line matches
  "runaway-hog" and asks it to terminate. (A tight `while :; do :; done` loop
  like this one responds to SIGTERM fine; if something ever ignored it you'd
  escalate with `sudo pkill -9 -f runaway-hog`.)

---

CHECK IT WORKED

  Confirm nothing matches any more. pgrep exits non-zero (failure) when it
  finds nothing — which is exactly the success we want here:

```run
pgrep -af runaway-hog || echo "gone - no runaway-hog process left"
```

  The grader passes only when `pgrep -f runaway-hog` finds nothing, i.e. no
  process running the hog remains.

---

GOTCHAS

  - Use `-f` when matching. The interpreter (bash) is the real program name,
    so `pgrep runaway-hog` without `-f` finds nothing and you'd wrongly think
    it wasn't running.
  - Kill the process, not the script file. The task doesn't want the .sh
    deleted — just the running instance stopped.
  - Watch out for the grep-catches-itself trap: `ps -ef | grep runaway`
    matches your own grep command too. Add `| grep -v grep`, or just use
    pgrep, which never lists itself.
  - Only escalate to `-9` (SIGKILL) if a plain TERM won't work — SIGKILL
    gives the process no chance to clean up.
