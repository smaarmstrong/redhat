THE IDEA

  A cron job is a command plus a schedule (minute, hour, day-of-month, month,
  day-of-week). Ansible manages them with:

    ansible.builtin.cron

  The clever part: you give each job a `name:`, and Ansible writes a marker
  comment above the entry (# Ansible: nightly-backup). That name is the job's
  identity — it's how the module finds the entry again on the next run to stay
  idempotent, instead of appending a duplicate every time.

  This task creates a root cron job named `nightly-backup` running
  /usr/local/bin/backup.sh every day at 02:15. setup.sh cleared any old
  entry. Working directory: /opt/rhce/cron/.

---

  Look at root's crontab now — it should have no backup entry:

```run
sudo crontab -l 2>/dev/null || echo "(no crontab yet)"
```

  Empty or missing. After the playbook, one scheduled line will appear here.

---

WHY IT MATTERS

  Scheduling recurring jobs is a standard admin task, and doing it through the
  cron module (rather than editing crontabs by hand) gives you the named,
  idempotent, repeatable behaviour the exam is testing. The named-marker
  trick is exactly why a well-written cron task passes the "run twice,
  changed=0" check where a hand-appended line would not.

---

HOW TO DO IT

  Write the playbook. Note each time field is a STRING (quote the numbers so
  YAML doesn't treat them oddly); user: root puts it in root's crontab:

```run
cd /opt/rhce/cron
cat > playbook.yml <<'EOF'
---
- name: Schedule nightly backup cron job
  hosts: managed
  become: true
  tasks:
    - name: Create nightly-backup cron job for root
      ansible.builtin.cron:
        name: nightly-backup
        user: root
        minute: "15"
        hour: "2"
        day: "*"
        month: "*"
        weekday: "*"
        job: /usr/local/bin/backup.sh
        state: present
EOF
```

  minute "15" and hour "2" give 02:15; day, month and weekday default to "*"
  (every one), so writing them is optional but makes the schedule explicit.
  `job:` is the command to run. `name:` is the identity marker described above.

---

  Run it:

```run
cd /opt/rhce/cron && ansible-playbook playbook.yml
```

  changed=1. Now re-run for the idempotence check:

```run
cd /opt/rhce/cron && ansible-playbook playbook.yml
```

  changed=0 — the module found the entry by its name and saw it already
  matches, so it left the crontab alone (no duplicate line).

---

CHECK IT WORKED

  The grader reads root's crontab and looks for the 15 2 * * * schedule
  pointing at backup.sh, plus the nightly-backup name. Look yourself:

```run
sudo crontab -l
```

  You should see a `# Ansible: nightly-backup` comment and a line
  `15 2 * * * /usr/local/bin/backup.sh`.

---

GOTCHAS

  - The `name:` is not cosmetic — it's how the module recognises the job later
    to stay idempotent. Omit it and repeated runs pile up duplicate entries.
  - Quote the time fields ("15", "2"). Unquoted, YAML reads them as integers;
    the module accepts that, but quoting is the safe habit and required for
    things like "*/5".
  - user: root targets root's crontab. Leave it off and it defaults to root
    here anyway (become makes you root), but be explicit.
  - It's minute/hour/day/month/weekday — don't cram them into one string.
