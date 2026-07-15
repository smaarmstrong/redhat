THE IDEA

  firewalld is the firewall manager on RHEL. It groups rules into zones,
  and each zone has a list of allowed "services" — named bundles of ports
  (cockpit, ssh, http, and so on). Allowing the cockpit service opens the
  ports Cockpit's web console listens on; removing it closes them.

  The critical thing about firewall-cmd is that it manages TWO
  configurations:

    - the RUNTIME config: the live rules in the kernel right now. Changes
      here take effect instantly but vanish on reload or reboot.
    - the PERMANENT config: the on-disk rules that get loaded at boot.
      Changes here persist but do NOT affect the running firewall until you
      reload.

  A complete change touches both — and that's the whole skill being tested.

---

  The setup allowed cockpit in the default zone, both ways. Confirm it's
  currently open. The permanent config:

  Note: firewall-cmd talks to firewalld over polkit, so even the
  read-only queries fail for a normal user — every firewall-cmd here
  is prefixed with `sudo`, a normal user who's been granted sudo,
  exactly the exam setup.

```run
sudo firewall-cmd --permanent --query-service=cockpit
```

  And the runtime config:

```run
sudo firewall-cmd --query-service=cockpit
```

  Both print "yes". Our job is to make both say "no".

---

WHY IT MATTERS

  Closing off a service you don't need is basic attack-surface reduction,
  and Cockpit — a remote admin console — is exactly the kind of thing you'd
  lock down. The exam always wants firewall changes to persist across a
  reboot, so the permanent config is non-negotiable; but a change that
  doesn't also take effect now is only half a fix.

---

HOW TO DO IT

  Step 1 — remove the service from the PERMANENT config. Note that
  --permanent commands change only the on-disk config; the live firewall is
  untouched for now:

```run
sudo firewall-cmd --permanent --remove-service=cockpit
```

  It prints "success". If you re-ran the runtime query right now, cockpit
  would still show as allowed — because we've only edited the permanent
  side.

---

  Step 2 — reload, so firewalld reads the permanent config back into the
  running firewall. This is what pushes the change live:

```run
sudo firewall-cmd --reload
```

  reload re-applies the permanent config to runtime in one step, which is
  the tidy way to make both configs agree. (You could instead run the same
  --remove-service without --permanent to change only runtime, but then
  you'd be maintaining two commands; reload keeps them in sync.)

---

CHECK IT WORKED

  Both queries should now fail. Permanent:

```run
sudo firewall-cmd --permanent --query-service=cockpit
```

  Runtime:

```run
sudo firewall-cmd --query-service=cockpit
```

  Both should print "no" (and exit non-zero). The grader checks exactly
  that: firewalld running, cockpit not allowed in the permanent config, and
  not allowed in runtime after the reload.

---

GOTCHAS

  - Two configs. --remove-service without --permanent changes only runtime
    (reverts on reboot); with --permanent only, it doesn't take effect
    until a reload. Do the permanent removal AND reload.
  - --reload re-applies the whole permanent config, which also discards any
    unsaved runtime-only tweaks — expected here, worth knowing generally.
  - These act on the DEFAULT zone unless you pass --zone. That's what the
    task wants, so no --zone is needed.
  - Don't stop or disable firewalld to "block" the service — that tears
    down the entire firewall. Remove the one service instead.
