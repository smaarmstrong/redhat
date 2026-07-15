THE IDEA

  grep answers one question, fast: "which LINES of this text contain
  this thing?" You give it a pattern and a file; it prints every line
  where the pattern appears and stays quiet about the rest:

    grep PATTERN FILE

  That's it. The pattern can eventually be a regular expression (a
  whole language of its own — that's the NEXT lesson), but grep is
  already a workhorse with plain text patterns, and that's where to
  start.

---

  Meet the file we'll be filtering — a small application log:

```run
cat /opt/found/loglab/app.log
```

  Twelve lines: INFO chatter, DEBUG noise, and a few errors and
  warnings — in inconsistent letter case, the way real logs are.

---

WHY IT MATTERS

  "Find the line" is half of system administration: which log line has
  the failure, which line of the config sets the option, which file
  under /etc mentions this hostname. The exam gives grep its own
  objective, and the fault-finding tasks quietly assume you reach for
  it without thinking.

---

THE BASICS

  All the ERROR lines:

```run
grep ERROR /opt/found/loglab/app.log
```

  Two lines. But look back at the full log — there's also a lowercase
  "error" line hiding in there, and grep is CASE-SENSITIVE by default.
  `-i` (ignore case) catches every spelling:

```run
grep -i error /opt/found/loglab/app.log
```

  Three lines now. A habit worth forming when searching logs: humans
  are inconsistent with case, so -i by default.

---

  A few more flags you'll use daily. `-n` prefixes each match with its
  line number — essential when you're about to edit the file:

```run
grep -n -i warning /opt/found/loglab/app.log
```

  `-c` counts matching lines instead of printing them:

```run
grep -c -i error /opt/found/loglab/app.log
```

---

INVERT IT:  -v

  Sometimes the job is "everything EXCEPT". `-v` flips grep: print the
  lines that do NOT match. Strip the DEBUG noise:

```run
grep -v DEBUG /opt/found/loglab/app.log
```

  Same log, ten lines, no DEBUG. This is the standard way to de-noise
  output — and it chains beautifully with pipes from the last lesson:

```run
grep -v DEBUG /opt/found/loglab/app.log | grep -i -c error
```

  "Drop the DEBUG lines, then count the error lines among what's left."

---

SEARCHING MANY FILES:  -r

  Point grep at a directory with `-r` (recursive) and it searches every
  file underneath, printing filename:line for each hit. Try it on real
  system config:

```run
grep -r "PermitRootLogin" /etc/ssh/ 2>/dev/null
```

  (The 2>/dev/null discards "permission denied" complaints from files a
  normal user can't read — stderr redirection, from the last lesson,
  already earning its keep.) On the exam, `grep -rn something /etc/` is
  often the fastest way to find WHICH file to edit.

---

CHECK IT WORKED

  The graded task asks you to save three filtered views of app.log —
  errors.txt, warnings.txt, nodebug.txt — using exactly these tools plus
  `>` redirection. For example, the first one is:

```run
grep -i error /opt/found/loglab/app.log > /opt/found/loglab/errors.txt
cat /opt/found/loglab/errors.txt
```

  The grader compares your files line-for-line against the same
  filters, so let grep do the work — don't retype lines by hand.

---

GOTCHAS

  - Case sensitivity. "ERROR" won't match "error" without -i. When a
    search comes up empty, try -i before concluding the text isn't there.
  - Quote patterns with spaces or shell characters:
    grep "connection refused" file — without quotes, "refused" is
    treated as a filename.
  - No output does NOT mean grep is broken — it means no line matched.
    (grep also exits non-zero then, which matters later in scripts.)
  - Argument order: pattern FIRST, then files. `grep file pattern`
    searches "pattern" as if it were a file, and fails confusingly.
  - Some characters do extra things in a grep pattern: . * [ ] ^ $ are
    regular-expression operators, not literal text. `grep 192.168.0.1`
    matches more than you expect. That's the next lesson.
