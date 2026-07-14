THE IDEA

  RHEL/Rocky 9 uses firewalld, driven by firewall-cmd. Often you allow a
  named service (like "http"), but sometimes what you want to open has no
  predefined service name — a custom application listening on, say, TCP 8080.
  For that you open the PORT directly, specified as number/protocol, e.g.
  8080/tcp.

  And the concept that governs everything with firewalld is RUNTIME versus
  PERMANENT:

    runtime     the rules live in the firewall right now; lost on reload
                or reboot
    permanent   the rules written to disk; reloaded every time firewalld
                starts

  A bare `firewall-cmd --add-port=8080/tcp` changes only the runtime — gone
  after a reboot. `--permanent` changes only the on-disk config — not active
  until you reload. A complete change does BOTH.

---

  Check firewalld is up and see which ports are open in the default zone:

```run
sudo firewall-cmd --list-ports
```

  8080/tcp isn't there yet — that's what we're going to add.

---

WHY IT MATTERS

  Plenty of services listen on ports that firewalld has no built-in name for,
  and 8080 (common for app servers and proxies) is a perfect example. If the
  firewall doesn't allow it, clients just hang. Opening a specific port is a
  standard task, and the exam wants it to persist — the grader reboots the
  machine and checks BOTH the permanent and the runtime config, so half a job
  fails half the checks.

---

HOW TO DO IT

  Step one: add the port to the PERMANENT config. Note the port/protocol
  form — you must say tcp (or udp); a bare number is rejected. This writes to
  disk but doesn't touch the running firewall yet:

```run
sudo firewall-cmd --permanent --add-port=8080/tcp
```

  It prints "success". At this point the live firewall still doesn't allow
  8080 — the rule is only on disk.

  Step two: reload, which re-reads the permanent config into the running
  firewall, making the rule active immediately without dropping existing
  connections:

```run
sudo firewall-cmd --reload
```

  Now 8080/tcp is open in both places: on disk (survives reboot) and live
  (active now).

---

CHECK IT WORKED

  The grader checks that firewalld is running, that 8080/tcp is in the
  permanent config, and that it's in the runtime config. Query each:

```run
sudo firewall-cmd --permanent --query-port=8080/tcp
```

```run
sudo firewall-cmd --query-port=8080/tcp
```

  Both should print "yes" — the permanent check and the runtime check, the
  two the grader runs.

---

GOTCHAS

  - Two places. Opening the port without --permanent (active now, gone on
    reboot) or with --permanent but no reload (on disk but not active) each
    fails one grader check. You need permanent AND reload.
  - Always include the protocol: 8080/tcp, not 8080. firewalld requires
    port/protocol and will error on a bare number.
  - --reload loads the permanent config into runtime; it does NOT save
    runtime changes to disk. In fact it discards any runtime-only rules, so
    don't rely on an unsaved rule surviving.
