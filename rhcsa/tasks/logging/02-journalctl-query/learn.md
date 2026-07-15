THE IDEA

  journalctl is how you read the systemd journal. On its own it dumps
  everything, oldest first — useless in a real incident. The skill is
  FILTERING: narrowing millions of lines down to the handful you need.

  Two filtering ideas combine here:

    - journalctl's own filters, which query the journal's structured fields.
      `-t TAG` (short for --identifier) keeps only messages logged under a
      given syslog tag — like `rhcsa-drill`.

    - plain text tools on the output. Piping journalctl into `grep` picks
      lines containing a string, e.g. an error code.

  The setup has already seeded the journal: several messages tagged
  rhcsa-drill, some carrying code=4711 and some decoys with other codes. Our
  job is to pull out just the 4711 ones and save them to /root/drill.txt.

---

  First, see everything under that tag. `--no-pager` prints straight to the
  terminal instead of opening less (essential when you want to pipe or
  redirect):

```run
journalctl -t rhcsa-drill --no-pager
```

  You'll see a mix — some lines say code=4711, others say 1000, 2000, and so
  on. Those decoys are what we must exclude.

---

WHY IT MATTERS

  "Locate and interpret system logs and journals" is a core objective, and in
  practice nobody scrolls the whole journal — you filter by unit, tag,
  priority, or time, then grep for the detail. Combining a journalctl field
  filter with grep is the everyday move.

---

HOW TO DO IT

  Chain the two filters and redirect to the file. First the tag filter to get
  only rhcsa-drill lines, then grep to keep only those containing 4711, then
  write the result to /root/drill.txt.

  That file sits under /root, which belongs to root, so we pipe the
  filtered lines to `sudo tee` to write it as root — a normal user
  who's been granted sudo, exactly the exam setup. (Reading the journal
  above needed no sudo: your account is in the `wheel` group, which may
  read the full journal.)

```run
journalctl -t rhcsa-drill --no-pager | grep 4711 | sudo tee /root/drill.txt > /dev/null
```

  Read left to right: journalctl produces the tagged lines, grep throws away
  everything without "4711", and the survivors land in /root/drill.txt.
  Filtering by the tag FIRST matters — it guarantees no unrelated message
  that happens to contain 4711 sneaks in.

---

CHECK IT WORKED

  Look at what you captured:

```run
sudo cat /root/drill.txt
```

  Every line should be an rhcsa-drill message containing 4711, and none of
  the decoys. Count them if you like:

```run
sudo wc -l /root/drill.txt
```

  The grader rebuilds the expected set the same way — `journalctl -t
  rhcsa-drill | grep 4711` — and compares it (sorted, trailing space
  trimmed) against your file, so the file must hold exactly those lines.

---

GOTCHAS

  - Use --no-pager (or pipe, which disables the pager anyway). Without it an
    interactive session can hang in less; when redirecting it's cleaner to be
    explicit.
  - Filter by the tag, not just grep for 4711 across the whole journal — an
    unrelated service could log "4711" and pollute your file. `-t rhcsa-drill`
    scopes it correctly.
  - `>` writes the file; `>>` would APPEND. If you run it twice with >> you'd
    get duplicates and fail the exact-match check. Stick with `>`.
  - -t is the same as --identifier. Don't confuse it with -u (a systemd unit)
    — these messages come from `logger`, so they have a tag, not a unit.
