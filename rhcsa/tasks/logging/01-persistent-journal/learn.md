THE IDEA

  On RHEL 9 the systemd journal (journald) is the central log store. By
  default it keeps everything in memory under /run/log/journal — fast, but
  RAM is wiped on every reboot, so all your log history vanishes when the box
  restarts. That's exactly when you most want the logs: to see what happened
  before a crash.

  Making the journal PERSISTENT means telling journald to write to disk under
  /var/log/journal instead. Two things have to be true:

    1. the directory /var/log/journal must exist, and
    2. journald must be configured with Storage=persistent

  With Storage=persistent (or even the default "auto"), journald writes to
  /var/log/journal whenever that directory is present. So really the
  directory is the switch and the config makes the intent explicit.

---

  See where the journal lives right now. This reports the disk usage and
  paths journald is using:

```run
journalctl --disk-usage
```

  On this volatile setup you'll see it pointing at /run/log/journal (memory),
  not /var/log/journal. Let's fix that.

---

WHY IT MATTERS

  "Preserve system journals" is a named exam objective, and losing your logs
  on reboot is a real operational blind spot. This is also a persistence
  task in disguise — the whole point is that the change survives a restart,
  which is the exam's golden rule.

---

STEP 1 — configure Storage=persistent

  The cleanest way is a drop-in file rather than editing the big main config.
  Anything under /etc/systemd/journald.conf.d/ overrides journald.conf, so
  create the directory and a small file.

  These paths live under /etc (root-owned), so the commands that create
  and change them are prefixed with `sudo` — a normal user who's been
  granted sudo, exactly the exam setup. (The `journalctl` read above
  needed no sudo: your account is in the `wheel` group.)

```run
sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/persistent.conf <<'EOF'
[Journal]
Storage=persistent
EOF
```

  (You could instead uncomment and set Storage=persistent directly in
  /etc/systemd/journald.conf — the grader accepts either. Drop-ins are the
  tidy, upgrade-safe habit.)

---

STEP 2 — create the storage directory

  journald only writes to disk if the directory is there:

```run
sudo mkdir -p /var/log/journal
```

---

STEP 3 — apply it

  Restart journald so it re-reads the config and starts using the directory.
  (`systemd-tmpfiles --create` would set the correct ownership/ACLs too, but a
  restart is enough here.)

```run
sudo systemctl restart systemd-journald
```

---

CHECK IT WORKED

  The directory now exists and should start filling with per-machine journal
  files:

```run
ls -l /var/log/journal
```

  And journald should report it's writing to that persistent path now:

```run
journalctl --disk-usage
```

  The grader checks the two things that matter: /var/log/journal exists, and
  Storage=persistent is set somewhere under journald.conf or its .conf.d
  drop-ins.

---

GOTCHAS

  - Both pieces are required together. The directory without the config, or
    the config without the directory, is the usual half-fail. Do both.
  - Don't confuse this with /etc/rsyslog.conf or files under /var/log/*.log —
    those are the older syslog world. This objective is about journald.
  - Storage=volatile means memory-only (what setup pinned it to); "auto"
    means "persistent if /var/log/journal exists". Setting it explicitly to
    persistent removes all doubt for the grader.
  - Remember to restart systemd-journald (or reboot) so the setting takes
    effect — a config on disk that hasn't been re-read does nothing yet.
