THE IDEA

  Some software moves faster than a whole RHEL release. You might want
  PostgreSQL 13 on one server and PostgreSQL 15 on another, without waiting
  for a new OS version. Application Streams (part of AppStream) solve this
  with "modules": a module is a named piece of software (like postgresql)
  offered in several parallel "streams", where each stream is a major
  version (13, 15, 16, ...).

  You "enable" one stream of a module to tell dnf: from now on, when I
  install packages from this module, give me THIS version. Enabling a
  stream doesn't install anything by itself — it just pins the version
  choice.

---

  See the streams available for the postgresql module. Run:

```run
dnf module list postgresql 2>/dev/null
```

  Each row is a stream. The columns show the module name, the stream
  (version), and profiles. A stream marked [e] is enabled and [d] is the
  distro default. Right now none should be [e] — setup reset the module so
  no stream is chosen yet.

---

WHY IT MATTERS

  Picking a specific application version is a real deployment decision, and
  the exam objective ("install and update software packages") includes
  driving AppStream. Knowing enable/disable/reset for modules is the piece
  most people forget.

  The choice is written to a state file under /etc/dnf/modules.d/, so it
  survives reboots and future dnf runs. It's persistent config, not a
  runtime setting.

---

HOW TO DO IT

  Enable version 15 of the postgresql module. The syntax is
  module:stream — here postgresql:15. The -y accepts the transaction:

```run
sudo dnf -y module enable postgresql:15
```

  dnf prints the modular dependencies it's enabling and confirms with
  "Complete!". Note what it did NOT do: it installed no PostgreSQL packages.
  Enabling a stream only records the version choice. (Installing would be a
  separate `dnf install postgresql-server`, which would then pull from the
  15 stream.)

---

CHECK IT WORKED

  List the module again and look for the enabled marker on the 15 row:

```run
dnf module list postgresql 2>/dev/null | grep -E 'postgresql\s+15'
```

  The 15 stream should now carry [e] (enabled). That's exactly one of the
  two things the grader accepts.

  The other is the persistent state file dnf just wrote. Read it:

```run
cat /etc/dnf/modules.d/postgresql.module
```

  You'll see stream = 15 and state = enabled recorded there — the on-disk
  proof that survives a reboot.

---

GOTCHAS

  - Needs module metadata. Modules only exist if a repo that carries them
    (the Rocky AppStream repo) is enabled. On a box with no AppStream, `dnf
    module list postgresql` says "No matching Modules" and this task can't
    be done.
  - enable vs install: enabling a stream does NOT install packages. If the
    task also wanted the software running you'd follow up with `dnf install`.
  - Switching streams: you can't just enable a different stream over an
    active one cleanly — `dnf module reset postgresql` first, then enable
    the one you want. reset clears the choice back to "no stream selected".
  - Use the colon form module:stream (postgresql:15), not a space.
