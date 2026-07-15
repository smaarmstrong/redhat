THE IDEA

  A systemd timer is the modern alternative to cron. Instead of one crontab
  line, you write TWO unit files that work as a pair:

    a .service unit   describes WHAT to run (the command)
    a .timer unit     describes WHEN to run it (the schedule)

  The timer's job is simply to start a service of the same name at the right
  moment. So sitecheck.timer fires and starts sitecheck.service, which runs
  your script and exits. Splitting "what" from "when" is the whole design:
  you can trigger the same service by hand, from a timer, or from another
  unit, without duplicating anything.

  Because the script here just runs once and finishes (rather than staying
  alive like a daemon), the service is Type=oneshot — systemd expects it to
  start, do its work, and exit cleanly.

---

  The script we need to run already exists. Take a quick look:

```run
cat /usr/local/bin/sitecheck.sh
```

  Nothing to change there. Our job is to wrap it in a service and drive it
  with a daily timer.

---

WHY IT MATTERS

  RHEL is steadily moving scheduled work from cron to systemd timers, and the
  exam objective lists both. Timers bring real advantages: their runs are
  logged in the journal, they can catch up on missed runs after downtime
  (Persistent=true), and they show up in one place — `systemctl list-timers`.
  Knowing the two-file pattern and how to enable it is the skill.

---

STEP 1 — write the .service

  Custom units live under /etc/systemd/system. Create the service that runs
  the script as a oneshot:

  Note: /etc/systemd/system is owned by root and you're a normal
  user, so the commands that write unit files and drive systemd are
  prefixed with `sudo` — a normal user who's been granted sudo,
  exactly the exam setup. (Reading needs no sudo, which is why the
  earlier `cat` didn't.)

```run
sudo tee /etc/systemd/system/sitecheck.service <<'EOF'
[Unit]
Description=Site check maintenance task

[Service]
Type=oneshot
ExecStart=/usr/local/bin/sitecheck.sh
EOF
```

  ExecStart is the command; Type=oneshot tells systemd this unit runs to
  completion rather than staying resident. A oneshot service needs no
  [Install] section of its own — the timer is what gets enabled.

---

STEP 2 — write the .timer

  Now the schedule. OnCalendar=daily means "every day at 00:00". Persistent
  makes it run as soon as possible after boot if the machine was off when it
  was due:

```run
sudo tee /etc/systemd/system/sitecheck.timer <<'EOF'
[Unit]
Description=Run sitecheck daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

  The naming is the magic: because the timer is called sitecheck.timer, it
  automatically starts sitecheck.service. (If you wanted them named
  differently you'd add a Unit= line under [Timer], but matching names is the
  clean way.) WantedBy=timers.target is what lets it start at boot once
  enabled.

---

STEP 3 — reload and enable

  systemd doesn't see new files on disk until you tell it to re-read them:

```run
sudo systemctl daemon-reload
```

  Then enable AND start the timer in one step. `--now` starts it immediately;
  `enable` wires it into timers.target so it comes back after a reboot:

```run
sudo systemctl enable --now sitecheck.timer
```

---

CHECK IT WORKED

  Confirm the timer is enabled (this is the persistence the grader checks):

```run
systemctl is-enabled sitecheck.timer
```

  And confirm it's live and scheduled — it should appear in the timer list
  with a NEXT run time:

```run
systemctl list-timers --all | grep sitecheck
```

  The grader verifies both unit files exist, the service is Type=oneshot and
  runs sitecheck.sh, the timer is enabled, and it shows in list-timers —
  everything you just did.

---

GOTCHAS

  - Enable the .timer, never the .service. The service is oneshot and has no
    [Install] section — enabling it makes no sense. The timer drives it.
  - Forgetting `daemon-reload` after writing the files means systemd never
    sees them, and enable fails. Reload first.
  - `enable` alone wires it for the next boot but doesn't start it now; use
    `--now` (or a separate `start`) so it also appears in list-timers today.
  - Timer and service must share a base name (sitecheck) unless you add an
    explicit Unit= in [Timer].
