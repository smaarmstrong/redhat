THE IDEA

  cron is the classic Unix job scheduler: a daemon (crond) that wakes up
  every minute, reads a set of tables called "crontabs", and runs whatever
  command is due. Each user has their own crontab, and root's is just one
  more of them.

  A crontab entry is a single line with five time fields followed by the
  command to run:

    minute  hour  day-of-month  month  day-of-week   command

  A `*` in any field means "every value". So "every day at 03:30" is:

    30   3   *   *   *   /usr/local/bin/backup.sh
    |    |   |   |   |
    |    |   |   |   +-- day of week: any
    |    |   |   +------ month: any
    |    |   +---------- day of month: any
    |    +-------------- hour: 3
    +------------------- minute: 30

---

  Let's look at what root's crontab holds right now. Because this is
  ROOT's crontab (stored under /var/spool/cron/, owned by root), every
  crontab command here is prefixed with `sudo` — a normal user who's
  been granted sudo, exactly the exam setup. Run:

```run
sudo crontab -l
```

  If it prints nothing (or "no crontab for root"), that's fine — root simply
  has no scheduled jobs yet. We're about to add one.

---

WHY IT MATTERS

  "Run this backup/report/cleanup every night" is one of the most common
  real sysadmin jobs, and the exam tests it directly. The key word is
  recurring: a crontab lives in a file on disk (under /var/spool/cron/), so
  it survives a reboot automatically — no enabling required. Get the five
  time fields right and you are done.

---

HOW TO DO IT

  You edit a crontab with `crontab -e`, which opens your editor. That's the
  normal interactive way, but it's awkward to script inside a lesson, so
  we'll do the exact same thing non-interactively: read the current crontab,
  add our line, and pipe the result back in.

  First, so re-running is safe, strip any old backup.sh line, then append
  the new schedule and install it:

```run
( sudo crontab -l 2>/dev/null | grep -v '/usr/local/bin/backup.sh'; echo "30 3 * * * /usr/local/bin/backup.sh" ) | sudo crontab -
```

  Piping a line ending in `crontab -` replaces root's crontab with whatever
  arrives on standard input. In the exam you would just run `sudo crontab -e`
  and type the one line

    30 3 * * * /usr/local/bin/backup.sh

  by hand — same result, either way.

---

CHECK IT WORKED

  List root's crontab again and you should see your line:

```run
sudo crontab -l
```

  That "30 3 * * * /usr/local/bin/backup.sh" line is exactly what the grader
  looks for: minute 30, hour 3, every day, running the backup script.

---

GOTCHAS

  - Field order is minute THEN hour. "3:30 AM" is `30 3`, not `3 30`. Getting
    these two backwards is the classic cron mistake.
  - Use `crontab -e` (or the pipe above), not a stray file you drop somewhere.
    Editing root's real crontab is what makes it persistent and owned by root.
  - `crontab -r` REMOVES the whole crontab — dangerously close to `-e` on the
    keyboard. Don't fat-finger it.
  - A user crontab has five time fields. (The system files in /etc/cron.d and
    /etc/crontab have a sixth "user" field — different format, not what this
    task wants.)
