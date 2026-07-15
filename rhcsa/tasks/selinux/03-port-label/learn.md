THE IDEA

  SELinux labels aren't just for files — network ports carry types too. The
  policy says which service type is allowed to bind which port. The web
  server type, for example, may only listen on ports labelled http_port_t
  (80, 443, 8080, a few others by default). Try to start it on some other
  port and SELinux blocks the bind, even though nothing else is wrong.

  So when you want a service to run on a non-standard port, you don't fight
  SELinux — you tell it that port belongs to the right type. That's a port
  label, managed with semanage port.

---

  Let's see what type currently owns the http ports. TCP 8888 is NOT in the
  list yet (the setup made sure of that):

  Note: even listing SELinux port labels with `semanage port -l`
  requires root, as does adding one, so these commands are prefixed
  with `sudo` — a normal user who's been granted sudo, exactly the
  exam setup.

```run
sudo semanage port -l | grep ^http_port_t
```

  You'll see the standard ports there — 80, 443, 8080, and so on — but no
  8888. We're going to add it.

---

WHY IT MATTERS

  "Run the web server on port 8888" is a two-part job on RHEL: open the
  firewall AND label the port for SELinux. Admins who forget the second
  half get a service that refuses to start with a cryptic permission error.
  The exam isolates that SELinux half.

  Persistence matters as always: the label has to survive a reboot, and the
  grader re-checks with semanage port -l after rebooting.

---

HOW TO DO IT

  One command. semanage port -a adds a port mapping; -t sets the type; -p
  chooses the protocol (tcp here):

```run
sudo semanage port -a -t http_port_t -p tcp 8888
```

  Good news on persistence: semanage writes straight into the policy store,
  so there is no separate "make it permanent" step and no runtime-only
  trap here — unlike setsebool, semanage changes are persistent by nature.

---

CHECK IT WORKED

  List the http ports again and look for 8888:

```run
sudo semanage port -l | grep ^http_port_t
```

  8888 should now appear in that line's port list. That's exactly what the
  grader inspects — an http_port_t tcp entry containing 8888.

---

GOTCHAS

  - Use -a to ADD a brand-new port label. If the port is already defined
    under a different type, -a fails with "already defined"; use -m
    (modify) to reassign it instead.
  - Get the protocol right. -p tcp and -p udp are separate namespaces;
    labelling tcp 8888 does nothing for udp 8888.
  - Labelling the port is only the SELinux piece. In real life you'd still
    open it in firewalld — but this task is scoped to the SELinux label.
  - To undo one later: semanage port -d -p tcp 8888.
