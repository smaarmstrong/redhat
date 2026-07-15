THE IDEA

  Where grep thinks in LINES, awk thinks in COLUMNS. It reads a line,
  splits it into fields, and hands you each piece by number:

    $1  the first field      $2  the second      ...and so on
    $0  the whole, unsplit line
    NF  how many fields this line has (so $NF is the last one)

  The command shape is:

    awk 'PATTERN { ACTION }' file

  For every line that matches PATTERN, do ACTION. Both halves are
  optional: leave out the pattern and the action runs on EVERY line;
  leave out the action and the default is "print the whole line".
  The action you'll use most is print.

  By default awk splits on whitespace. Structured files use other
  separators — colons in /etc/passwd, commas in CSVs — and -F sets
  the field separator:  awk -F: '...'

---

  The practice file is a small staff register, one record per line,
  colon-separated — username:department:city:budget:

```run
cat /opt/found/awklab/staff.txt
```

---

WHY IT MATTERS

  Half the files an admin reads are field-structured: /etc/passwd,
  /etc/fstab, mount tables, ps and df output. "Give me just the
  usernames" or "which entries have field 3 equal to X" is an awk
  one-liner. It turns up in the exam's text-processing objective and
  in scripts you'll inherit — better to read it than to fear it.

---

PICKING A COLUMN

  Every username — field 1, split on colons:

```run
awk -F: '{print $1}' /opt/found/awklab/staff.txt
```

  Unpack it: -F: says "fields are separated by colons"; there's no
  pattern, so the action runs on every line; and the action prints
  field 1. Note the single quotes around the program — without them
  the SHELL would try to expand $1 itself (to nothing) before awk ever
  ran. Single-quote awk programs, always.

---

SEVERAL COLUMNS AT ONCE

  print takes a list. A comma between items puts a space between them
  in the output:

```run
awk -F: '{print $1, $3}' /opt/found/awklab/staff.txt
```

  Username and city, space-separated — a new report the original file
  never contained. That's awk's real trick: reshaping. (Try
  '{print $3, $1}' — column order is yours to choose. And on any line,
  $NF is the last field — the budget — however many fields there are.)

---

ADDING A CONDITION — the pattern half

  Now use the pattern slot: only Engineering records. A pattern can be
  a comparison; == tests equality against a quoted string:

```run
awk -F: '$2 == "Engineering"' /opt/found/awklab/staff.txt
```

  No action given, so the default fires: print the whole line ($0).
  The three Engineering records, complete and untouched. Combine both
  halves — the pattern chooses lines, the action reshapes them:

```run
awk -F: '$2 == "Engineering" {print $1, $4}' /opt/found/awklab/staff.txt
```

  Engineering names with their budgets. Numbers compare numerically
  too — records with a budget over 1000:

```run
awk -F: '$4 > 1000 {print $1, $4}' /opt/found/awklab/staff.txt
```

---

TRY IT ON A REAL FILE

  /etc/passwd is exactly this shape — seven colon-separated fields,
  username first, login shell last. Every account's name and shell:

```run
awk -F: '{print $1, $NF}' /etc/passwd
```

  Reading a system file needs no special rights, and suddenly a file
  you'll see on every Linux box for the rest of your career is legible.

---

CHECK IT WORKED

  The graded task asks for three files — names.txt, locations.txt,
  engineering.txt — built from the three one-liners you just ran, saved
  with `>` redirection. For example:

```run
awk -F: '{print $1}' /opt/found/awklab/staff.txt > /opt/found/awklab/names.txt
cat /opt/found/awklab/names.txt
```

  The grader compares each file's exact contents, in the original
  record order — awk preserves order naturally, so let it do the work.

---

GOTCHAS

  - Single quotes around the program. In double quotes the shell
    expands $1 first and awk receives garbage. This is the number-one
    awk mystery.
  - The comma in print inserts a space. '{print $1 $3}' (no comma)
    glues the fields together: aliceLondon.
  - -F goes OUTSIDE the program: awk -F: '{...}' — not inside the
    quotes.
  - String values need their own quotes inside the program:
    $2 == "Engineering". Written unquoted, Engineering is treated as a
    (empty) variable and matches nothing.
  - awk vs cut: cut -d: -f1 also slices columns and is fine when
    that's all you need — but it can't filter, compare or reorder.
    awk grows with the problem, which is why it's the one worth
    learning first.
