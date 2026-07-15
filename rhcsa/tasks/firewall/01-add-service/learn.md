THE IDEA

  RHEL/Rocky 9 ships with a firewall managed by firewalld, and you drive it
  with the firewall-cmd command. firewalld groups rules into ZONES (the
  default one is usually "public"), and instead of remembering port numbers
  you can allow a named SERVICE — "http", "ssh", "https" and so on. firewalld
  knows that "http" means TCP port 80, so allowing the service is the tidy,
  readable way to open it.

  The one concept you must internalise is RUNTIME versus PERMANENT:

    runtime     the rules loaded in the live firewall right now; lost on
                reload or reboot
    permanent   the rules written to disk; reloaded every time firewalld
                starts

  A plain `firewall-cmd --add-service=http` changes only the runtime — gone
  after a reboot. `--permanent` changes only the on-disk config — not active
  until you reload. A complete change does BOTH.

---

  First confirm firewalld is up, and see that http isn't allowed yet.
  firewall-cmd talks to firewalld over polkit, so even a read-only
  listing fails for a normal user — every firewall-cmd here is
  prefixed with `sudo`, a normal user who's been granted sudo,
  exactly the exam setup.

```run
sudo firewall-cmd --list-services
```

  That lists the services currently allowed in the default zone. http is not
  in the list — that's the state we're fixing.

---

WHY IT MATTERS

  A web server is useless if the firewall silently drops the traffic on the
  way in. Opening the right service is an everyday task, and the exam always
  wants it to survive a reboot — the grader here literally reboots the box
  and checks BOTH the permanent and the runtime config. Do only one half and
  you fail one of the two checks.

---

HOW TO DO IT

  Step one: add the service to the PERMANENT configuration. This writes the
  rule to disk but does not touch the running firewall yet:

```run
sudo firewall-cmd --permanent --add-service=http
```

  It prints "success". If you stopped here, `firewall-cmd --list-services`
  would still not show http, because the live firewall hasn't been told
  about the new rule.

  Step two: reload, which re-reads the permanent config into the running
  firewall — making the rule active now, without dropping existing
  connections:

```run
sudo firewall-cmd --reload
```

  Now the rule is in both places: on disk (survives reboot) and live (active
  this instant).

---

CHECK IT WORKED

  The grader checks three things: firewalld is running, http is in the
  permanent config, and http is in the runtime config. You can query each:

```run
sudo firewall-cmd --permanent --query-service=http
```

```run
sudo firewall-cmd --query-service=http
```

  Both should print "yes". The first is the permanent check, the second the
  runtime check — exactly the two the grader runs.

---

GOTCHAS

  - Two places. The number-one mistake is running --add-service=http WITHOUT
    --permanent (active now, gone on reboot) or WITH --permanent but no
    reload (on disk but not active). You need permanent AND reload.
  - --reload re-reads the permanent config; it does NOT save the runtime.
    Never expect an unsaved runtime rule to survive a reload — reload
    actually discards runtime-only changes.
  - Allowing the "http" service opens port 80. If a task asked for HTTPS
    you'd use the "https" service (port 443) instead — the name maps to the
    port for you.
