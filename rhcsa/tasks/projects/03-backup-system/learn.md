THE IDEA

  This scenario wires three things together into an automated job: a
  SCRIPT that does the work, a systemd SERVICE that knows how to run it,
  and a TIMER that fires the service on a schedule. That service+timer
  pair is the modern systemd replacement for a cron job, and it's a listed
  exam objective. Broken into parts:

    1. a backup script at /usr/local/bin/backup.sh that tars /etc into
       /var/backups/etc-backup.tar.gz (executable, works with no args)
    2. the destination dir /var/backups, root:root, mode 0750
    3. backup.service (Type=oneshot, runs the script) + backup.timer
       (daily), with the TIMER enabled so it starts at boot

  A useful order: make the destination directory first, then the script
  (it writes there), then the units that call the script.

---

WHY IT MATTERS

  Scheduled maintenance jobs — backups, log rotation, reports — are daily
  reality, and systemd timers are how RHEL 9 does them: better logging
  (journalctl), dependency handling, and a Persistent= option that catches
  up a missed run after downtime. On the exam, the catch is persistence in
  two senses: the units must be ENABLED (so they come back after reboot),
  and the grader will actually RUN your script, so it has to genuinely
  produce a valid archive — not just look right.

---

HOW TO DO IT

  Note: this job lives in root-owned system paths (/var/backups,
  /usr/local/bin, /etc/systemd), so the commands that create or
  change it are prefixed with `sudo` — a normal user who's been
  granted sudo, exactly the exam setup. (Read-only checks like
  `systemctl is-enabled` need no sudo.)

  Part 2 first — the destination directory. `install -d` sets owner,
  group, and mode in one command. 0750 means root full, group read/execute,
  others nothing:

```run
sudo install -d -m 0750 -o root -g root /var/backups
```

---

  Part 1 — the script. Write it to /usr/local/bin/backup.sh. The clean way
  to archive /etc is `tar czf ARCHIVE -C / etc`: -C / changes into / first
  so the archive stores relative paths (etc/...) rather than a leading
  slash, and czf means create, gzip, to file. We also mkdir the dest
  inside the script so it stands alone. Note the quoted 'EOF' — that stops
  the shell expanding anything while writing the file:

```run
sudo tee /usr/local/bin/backup.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -e
mkdir -p /var/backups
tar czf /var/backups/etc-backup.tar.gz -C / etc
EOF
```

  Make it executable — the grader checks the -x bit and, more importantly,
  runs the file:

```run
sudo chmod 0755 /usr/local/bin/backup.sh
```

---

  Prove the script actually works before wiring a timer to it. Run it, then
  confirm the archive is a real gzip tar that contains /etc content:

```run
sudo /usr/local/bin/backup.sh
sudo file /var/backups/etc-backup.tar.gz
sudo tar -tzf /var/backups/etc-backup.tar.gz | grep -m1 etc/
```

  You want "gzip compressed data" and at least one etc/ path listed.

---

  Part 3 — the service unit. Type=oneshot suits a task that runs, finishes,
  and exits (as opposed to a long-running daemon). ExecStart points at our
  script:

```run
sudo tee /etc/systemd/system/backup.service >/dev/null <<'EOF'
[Unit]
Description=Backup /etc to /var/backups

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF
```

---

  Now the timer. A timer unit named backup.timer automatically drives the
  service of the SAME NAME (backup.service) — that name-matching is how the
  pair is linked. OnCalendar=daily fires it once a day; Persistent=true
  runs a missed job after the machine was off; and WantedBy=timers.target
  is what makes `enable` hook it into boot:

```run
sudo tee /etc/systemd/system/backup.timer >/dev/null <<'EOF'
[Unit]
Description=Run the /etc backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

---

  Reload systemd so it reads the new unit files, then ENABLE and start the
  timer. Enabling is the persistence step — it's what brings the timer back
  after reboot:

```run
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
```

---

CHECK IT WORKED

  The grader: confirms the script exists and is executable, RUNS it, and
  checks the produced archive is a valid gzip tar containing /etc; checks
  /var/backups is root:root mode 0750; checks both unit files exist, that
  the service is Type=oneshot with ExecStart on the script, that the timer
  is enabled, and that it shows up in list-timers. Verify the schedule side
  yourself:

```run
systemctl is-enabled backup.timer; systemctl list-timers --all | grep backup
```

---

GOTCHAS

  - The grader RUNS your script, so it must exit 0 and really create the
    archive. Test it by hand first, as we did.
  - ENABLE the timer (not just start it) — an un-enabled timer vanishes on
    reboot, and the grader checks is-enabled = enabled.
  - You enable the TIMER, not the service. The oneshot service is pulled in
    by the timer; enabling the service instead does nothing useful here.
  - The .timer and .service must share a base name so systemd pairs them
    automatically. If you name them differently you'd need Unit= in the
    [Timer] section.
  - Always daemon-reload after writing/editing unit files, or systemd
    keeps running the old definitions.
