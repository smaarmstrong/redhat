THE IDEA

  find walks a directory tree — every file, every subdirectory, all the
  way down — and prints the paths that pass your tests:

    find WHERE  TESTS...  ACTION

  WHERE is the starting directory. TESTS filter what gets reported:

    -name '*.log'    the filename matches this pattern (quote it!)
    -type f          it's a regular file      (-type d: a directory)
    -size +1M        bigger than 1 MiB        (-1M: smaller; 1M: exactly)
    -mtime -7        modified in the last 7 days
    -user alice      owned by alice

  The default ACTION is to print each path. Two others do work for you:

    -delete          delete what matched
    -exec CMD {} \;  run CMD on each match; {} stands for the path,
                     and the \; marks where the command ends

  Tests combine by just listing them (an unwritten AND between each).

---

  The practice tree — a few subdirectories of logs, sources, scratch
  files and data. Get the lay of the land (ls -R lists recursively):

```run
ls -R /opt/found/findlab
```

  Deep enough that "just look" stops scaling — which is find's cue.

---

WHY IT MATTERS

  "Find all files owned by X and copy them somewhere" is a stock RHCSA
  exam task, near-verbatim. In real life it's cleanup ("what's eating
  this disk?"), incident response ("what changed in the last hour?"),
  and housekeeping ("delete stale temp files"). find is also the tool
  that ACTS on what it finds — that's the half worth drilling.

---

FIND BY NAME

  All the log files, wherever they hide:

```run
find /opt/found/findlab -name '*.log'
```

  Three paths, from two different subdirectories. Those single quotes
  around '*.log' are load-bearing: unquoted, the SHELL expands *.log
  against the current directory before find runs, and you search for
  the wrong thing (or error out). Quote every -name pattern, always.

  find prints plain paths on stdout — so everything from the pipes
  lesson applies. Sort them into a file:

```run
find /opt/found/findlab -name '*.log' | sort > /opt/found/findlab/logfiles.txt
cat /opt/found/findlab/logfiles.txt
```

---

FIND BY TYPE AND SIZE

  Big files are found by size, not name. -size +1M means "strictly
  larger than 1 MiB"; -type f keeps directories out of the answer:

```run
find /opt/found/findlab -type f -size +1M
```

  One hit: data/big.bin. (Sizes take k, M, G suffixes; a leading +
  means "more than", - means "less than". -size 1M with no sign means
  "exactly", which is almost never what you want.) Check it with
  ls -lh (h prints human-readable sizes):

```run
ls -lh /opt/found/findlab/data
```

---

ACT ON WHAT YOU FOUND:  -exec

  Now make find DO something: copy every large file into a big/
  directory. -exec runs a command per match, with {} standing in for
  the path. Build the destination, then run it:

```run
mkdir -p /opt/found/findlab/big
find /opt/found/findlab -type f -size +1M -not -path '*/big/*' -exec cp {} /opt/found/findlab/big/ \;
ls -lh /opt/found/findlab/big
```

  Reading that find: type f, over 1 MiB, NOT inside big/ itself (once
  a copy lands there, IT is also a file over 1 MiB — skipping the
  destination avoids finding the copy on the same sweep), and for each
  match: cp <path> big/. The trailing \; is find's "end of command"
  marker — easy to forget, and find complains loudly without it.

---

DELETE — carefully

  The scratch .tmp files are scattered across the tree. The golden
  rule for destructive find: run it WITHOUT the action first and read
  the list — that's exactly what will be deleted:

```run
find /opt/found/findlab -name '*.tmp'
```

  Three files, all genuinely scratch. Same command, plus -delete:

```run
find /opt/found/findlab -name '*.tmp' -delete
find /opt/found/findlab -name '*.tmp'
```

  Second run prints nothing: all gone, and nothing else was touched.

---

CHECK IT WORKED

  You've already done the three graded jobs while following along —
  logfiles.txt written, .tmp files deleted, big.bin copied into big/.
  One sweep to confirm the end state:

```run
ls -R /opt/found/findlab
```

  The solo run afterwards resets the tree, and you'll do it again from
  scratch — that's where it sticks.

---

GOTCHAS

  - QUOTE the -name pattern: -name '*.log'. Unquoted stars are the
    single most common find failure, and the error ("paths must
    precede expression") is unhelpful.
  - Preview before you destroy. Run the find bare, read the list, THEN
    add -delete or -exec rm. There is no undo.
  - -delete only works where the expression puts it — at the END. As a
    first argument it's (dangerously) different; just always write the
    tests first, action last.
  - -exec needs its terminator: ... -exec cp {} /dest/ \; — forget the
    \; and find refuses to run. (Ending with + instead batches many
    files into one command — faster for thousands of matches.)
  - Searching system-wide (find / ...) as a normal user sprays
    "Permission denied" noise on stderr; discard it with 2>/dev/null —
    the redirection lesson strikes again.
  - -size rounds UP in units: -size +1M means strictly over 1 MiB, and
    file sizes with -size use disk-style units (k, M, G), not powers
    of ten.
