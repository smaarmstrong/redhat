THE IDEA

  rsync copies files, but cleverly: it compares source and destination and
  transfers only what differs, and it can preserve all the metadata a plain
  cp throws away — permissions, timestamps, ownership. That makes it the
  standard tool for backups and for mirroring one tree onto another, over
  the network or locally.

  The one flag to know is -a, "archive mode." It's shorthand for "recurse
  into subdirectories and preserve permissions, timestamps, ownership,
  symlinks — copy everything faithfully." Nearly every rsync command you'll
  write starts with -a.

---

  Setup gave us a populated /srv/source (files with deliberately odd modes
  and back-dated timestamps) and NO /srv/backup yet. Look at what we're
  copying:

```run
ls -lR /srv/source
```

  Note the permissions (640, 600, 644) and the old 2020 dates — a plain cp
  would stamp everything with today's date and default modes, which is why
  -a matters here.

---

WHY IT MATTERS

  "Securely transfer files between systems" is an RHCSA objective, and rsync
  (typically tunnelled over SSH) is how it's done in practice. Mirroring a
  directory while preserving metadata — and doing it incrementally so
  re-runs are cheap — is a daily backup-and-sync task for any admin.

---

HOW TO DO IT

  The whole job is one command. Two details make it a true MIRROR:

    - The trailing slash on the SOURCE. /srv/source/ means "the CONTENTS
      of source." Without the slash, rsync would create
      /srv/backup/source/... — a directory inside, not a mirror.
    - --delete removes anything in the destination that's no longer in the
      source, so the two trees match exactly (not just "source added to
      whatever was there").

  Run it:

```run
rsync -a --delete /srv/source/ /srv/backup/
```

  rsync creates /srv/backup for you. -a carried the odd permissions and the
  2020 timestamps across untouched.

---

CHECK IT WORKED

  The definitive test is to ask rsync itself what it WOULD still change. In
  dry-run mode it should find nothing:

```run
rsync -anic /srv/source/ /srv/backup/
```

  -n is dry-run (change nothing), -i itemizes each change, -c compares by
  checksum. Empty output means the mirror is perfect — which is exactly the
  grader's main check. Then eyeball that metadata really carried over:

```run
ls -lR /srv/backup
```

  The grader also confirms subdir/gamma.log made it across and that
  alpha.txt is still mode 640 in the copy.

---

GOTCHAS

  - The trailing slash on the source is the famous rsync gotcha. Slash =
    copy contents; no slash = copy the directory itself into the target.
    For a mirror of source's contents, you want /srv/source/.
  - Without --delete it's a sync, not a mirror: files deleted from source
    would linger in backup and the dry-run compare would still flag diffs.
  - Use -a. A bare cp -r (or rsync -r without -a) loses the permissions and
    timestamps, and the grader checks both — alpha.txt must stay 640.
  - Dry-run first (-n) when you're unsure; with --delete a wrong target
    path can wipe files. -n shows you the plan before you commit.
