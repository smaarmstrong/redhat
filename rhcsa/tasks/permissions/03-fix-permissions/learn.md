THE IDEA

  Half of permissions work isn't setting them from scratch — it's
  diagnosing why someone can't reach a file and fixing it with the LIGHTEST
  touch that works. Two things must both be true for a user to read a file:

    1. They can TRAVERSE every directory on the path to it. "Traverse" means
       execute (x) permission on each directory — x on a directory is the
       right to enter it and look inside.
    2. They can READ the file itself (r), via owner, group, or other.

  If either link is missing, access fails. So you diagnose from the top of
  the path down.

---

  Note: running a command as another user (`sudo -u intern`) and
  changing a root-owned file both need privilege, so those are
  prefixed with `sudo` — a normal user who's been granted sudo,
  exactly the exam setup. (The `ls` reads need no sudo.)

  The setup left /srv/reports/report.txt root-owned and mode 600, so the
  user intern can't read it. Let's SEE the problem exactly as intern would:

```run
ls -ld /srv/reports
ls -l /srv/reports/report.txt
sudo -u intern cat /srv/reports/report.txt
```

  The directory is 755 (drwxr-xr-x) — others have r-x, so intern CAN
  traverse it; that link is fine. The file is 600 (-rw-------) owned by
  root: only root can read it. That's the broken link, and the cat as intern
  should fail with "Permission denied".

---

WHY IT MATTERS

  "User X can't access file Y — fix it" is a pure RHCSA scenario and a daily
  support ticket. The discipline the exam rewards is fixing it WITHOUT
  overreaching: don't make a confidential file world-writable, and don't
  hand out more than the task needs. Read the situation, apply the minimal
  correct change.

---

HOW TO DO IT

  The directory is already traversable, so we only need to make the file
  readable by intern. intern isn't the owner and isn't in the file's group,
  so the practical minimal fix is to grant read to "other" — that's what the
  reference solution does. mode 644 keeps root's write, adds read for group
  and other, and leaves it NOT writable by anyone but root:

```run
sudo chmod 644 /srv/reports/report.txt
```

  A tighter, more surgical option is an ACL that grants ONLY intern:

    $ sudo setfacl -m u:intern:r /srv/reports/report.txt

  Either passes the grader (it just checks intern can read). The ACL leaks
  nothing to anyone else; 644 is simpler but makes the file world-readable.
  For a file marked "confidential", the ACL is the more principled choice —
  pick based on how sensitive the data is. We'll use 644 here since the
  grader accepts it and it's the simplest correct fix.

---

CHECK IT WORKED

  Re-run the exact thing that failed before, as intern:

```run
sudo -u intern test -r /srv/reports/report.txt && echo readable
sudo -u intern cat /srv/reports/report.txt
```

  It should now print "readable" and then the file contents. Those two
  checks — intern can read, and intern can actually cat it — are what
  grade.sh runs, along with confirming intern can traverse /srv/reports.

---

GOTCHAS

  - Diagnose the whole PATH, not just the file. If the directory had been
    700, fixing the file's mode alone wouldn't help — intern still couldn't
    enter the directory. Here the directory was already 755, so the file was
    the only problem.
  - x on a directory means "may traverse/enter", not "may execute". r on a
    directory means "may list names". They're separate; traversal only needs
    x.
  - Least privilege: the prompt explicitly says don't make it world-WRITABLE
    and don't over-grant. 644 gives read, not write — good. Reaching for 777
    would be wrong and sloppy.
  - Ownership is another lever: `chown intern report.txt` or
    `chgrp <a group intern is in>` plus a group-read bit would also work.
    Several correct paths; the grader checks the OUTCOME (intern can read),
    not which one you took.
