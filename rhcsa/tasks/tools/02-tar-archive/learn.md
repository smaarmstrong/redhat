THE IDEA

  `tar` bundles many files and directories into one file — a "tape
  archive", or tarball. On its own tar only bundles; it doesn't shrink
  anything. To compress you add gzip, and tar can call gzip for you with
  a single flag. The result is a .tar.gz (sometimes .tgz) file.

  The three flags you use over and over:

    c   create an archive
    z   filter it through gzip (compress)
    f   the archive FILE that follows

  So `tar -czf name.tar.gz things` reads as: create, gzip, into this
  file, from these things.

---

  Look at what we're archiving:

```run
ls -l /opt/logs
```

  Three little log files. We're going to pack the whole /opt/logs
  directory into /root/logs.tar.gz.

---

WHY IT MATTERS

  Backing up a directory, moving a config tree between machines, handing
  logs to someone — tar is the universal way to do it, and the exam has
  a dedicated objective for tar/gzip/bzip2. You need create, list, and
  extract at your fingertips. (bzip2 is the same idea with `j` instead of
  `z`; gzip's `z` is the common one.)

  This one is a plain deliverable — the archive just needs to exist on
  disk when grading runs.

---

HOW TO DO IT

  There's a subtlety worth teaching: the paths tar stores. If you run tar
  from / and name the directory as `opt/logs`, the archive stores the
  tidy relative path opt/logs/auth.log — not a leading-slash absolute
  path, which tar strips and warns about anyway. The clean way to force
  that is `-C /`, which tells tar to change into / first, then archive
  opt/logs.

  The archive lands in /root, which is owned by root and off-limits to
  a normal user, so we prefix the tar with `sudo` — a normal user
  who's been granted sudo, exactly the exam setup. (Reading /opt/logs
  above needed no sudo; the later steps that read back /root/logs.tar.gz
  do, since /root itself isn't yours to enter.)

```run
sudo tar -czf /root/logs.tar.gz -C / opt/logs
```

  That's the whole task. `-C /` then `opt/logs` gives you the paths the
  grader is looking for.

---

CHECK IT WORKED

  You don't have to unpack an archive to inspect it — list its contents
  with `t` (for "table of contents"):

```run
sudo tar -tzf /root/logs.tar.gz
```

  You should see opt/logs/ and the three .log files under it. That
  listing is exactly what the grader inspects (it greps for opt/logs and
  for auth.log / kern.log).

  Confirm it really is gzip data, not just named .gz:

```run
sudo file /root/logs.tar.gz
```

  It should say "gzip compressed data".

---

GOTCHAS

  - The `f` flag must be immediately followed by the filename. In
    `-czf /root/logs.tar.gz` the file comes right after. Get the order
    wrong (e.g. `-cfz`) and tar tries to use "z" as the filename.
  - Don't forget `z`. Without it you get an uncompressed .tar, and the
    grader's "gzip compressed data" check fails even though the file
    exists.
  - Feeding tar an absolute path (`/opt/logs`) works but tar strips the
    leading slash and prints a warning; using `-C / opt/logs` is the
    clean habit and stores the exact paths expected.
  - c creates, t lists, x extracts. Mixing them up is the classic slip.
