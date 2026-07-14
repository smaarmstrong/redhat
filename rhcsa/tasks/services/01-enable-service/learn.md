THE IDEA

  systemd manages the system's services (daemons) as "units". For any
  service there are two independent questions:

    is it ACTIVE?    is it running right now, this instant?
    is it ENABLED?   is it wired to start automatically at every boot?

  These are separate. A service can be running now but not enabled (it
  dies at the next reboot and never comes back), or enabled but not
  running now (it'll start next boot, but isn't up yet). A properly
  configured service is BOTH.

  This task's service is chronyd — the NTP daemon that keeps the clock
  in sync. setup.sh has disabled and stopped it, so right now it's
  neither active nor enabled.

---

  See the starting state for yourself:

```run
systemctl status chronyd --no-pager
```

  Look for two clues near the top: "Loaded: ... disabled" (won't start
  at boot) and "Active: inactive (dead)" (not running now). Both are
  wrong; we fix both.

---

WHY IT MATTERS

  This is THE canonical service task and the exam's golden rule in its
  purest form: the change has to survive a reboot. Start chronyd by
  hand and it runs now but is still disabled — reboot and the clock
  drifts again. The grader checks both is-enabled AND is-active
  precisely to catch the half-answer of only starting it.

---

HOW TO DO IT

  You could do it in two commands:

    systemctl start chronyd     # active now
    systemctl enable chronyd    # starts at boot

  But systemd gives you one command that does both at once — enable
  plus start — with the --now flag:

```run
sudo systemctl enable --now chronyd
```

  "enable" creates the boot-time symlink; "--now" also starts it
  immediately. One line, both requirements. It prints the symlink it
  created under /etc/systemd/system/....

---

CHECK IT WORKED

  Check each half — these are the exact two things the grader tests:

```run
systemctl is-enabled chronyd
```

  Should print "enabled" (starts at boot).

```run
systemctl is-active chronyd
```

  Should print "active" (running now). Two green words, task done.

---

GOTCHAS

  - enable alone ≠ start. `systemctl enable chronyd` sets up boot but
    does NOT start it now; you'd pass is-enabled and fail is-active.
    Likewise `start` alone passes is-active and fails is-enabled.
    --now covers both — that's why it's the go-to.
  - Don't confuse enabled with active. They answer different questions
    (boot-time vs right-now); the grader checks both on purpose.
  - Use the service name systemd knows. It's chronyd, not chrony. If
    unsure, `systemctl list-unit-files | grep chrony` shows the real
    unit name.
