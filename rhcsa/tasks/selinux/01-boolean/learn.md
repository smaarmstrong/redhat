THE IDEA

  SELinux ships with a huge, fixed policy that decides which processes may
  touch which files, ports and network resources. You rarely edit that
  policy directly. Instead the policy exposes dozens of on/off switches,
  called booleans, that flip whole chunks of it without recompiling
  anything.

  httpd_can_network_connect is one of them. Off (the default), the web
  server may serve pages but is forbidden from opening outbound network
  connections. Flip it on and Apache/PHP is allowed to reach databases,
  proxied back-ends, remote APIs and so on. It's the SELinux "yes, that
  process really is allowed to do that" knob.

---

  Let's see its current state. The setup already forced it OFF, so this
  should confirm that:

```run
getsebool httpd_can_network_connect
```

  It prints `httpd_can_network_connect --> off`. That's the value we have
  to change — and change in a way that sticks.

---

WHY IT MATTERS

  Half the "why won't my service talk to the database?" mysteries on RHEL
  are a boolean sitting off. Knowing to reach for getsebool/setsebool
  instead of disabling SELinux entirely is the difference between a real
  fix and a security hole.

  And the exam's golden rule is right here: the change has to survive a
  reboot. A boolean toggled the plain way is runtime-only and evaporates on
  the next boot, so it would score nothing.

---

HOW TO DO IT

  One command sets a boolean: setsebool. The trick is the -P flag ("P" for
  persistent). Without -P it changes only the value in memory; with -P it
  ALSO writes the value into the on-disk policy so it comes back after a
  reboot.

  Turn it on, persistently:

  Note: changing an SELinux boolean is privileged, so this command
  is prefixed with `sudo` — a normal user who's been granted sudo,
  exactly the exam setup. (Reading state with `getsebool` needs no
  sudo.)

```run
sudo setsebool -P httpd_can_network_connect on
```

  The -P version does a little more work under the hood (it rebuilds the
  boolean state in the policy store), so it takes a couple of seconds
  longer than the runtime-only form. That pause is normal.

---

CHECK IT WORKED

  First the runtime value:

```run
getsebool httpd_can_network_connect
```

  That should now say `on`. But runtime alone doesn't prove persistence.
  The tool that shows BOTH the current and the saved-to-disk value is
  semanage:

```run
sudo semanage boolean -l | grep httpd_can_network_connect
```

  Look at the pair in parentheses — you want (on   ,   on). The first is
  the running value, the second is what a reboot will restore. Both on
  means it persisted, which is exactly what the grader checks.

---

GOTCHAS

  - The classic fail is forgetting -P. `setsebool httpd_can_network_connect
    on` looks identical in getsebool right now, but the persisted value
    stays off and the reboot check fails. When in doubt, always use -P.
  - Don't "fix" a boolean problem by running setenforce 0 or disabling
    SELinux — that turns off the whole security model and still isn't
    persistent. Flip the specific boolean instead.
  - getsebool shows only the running value; use semanage boolean -l when
    you need to confirm the persisted one.
