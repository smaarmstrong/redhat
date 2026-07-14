THE IDEA

  Every command has three standard streams: input (stdin), output
  (stdout), and errors (stderr). The shell lets you re-wire them:

    >    send stdout to a file (overwrite / create it)
    >>   append stdout to a file
    2>   send stderr to a file
    |    a "pipe": feed one command's stdout into the next command's stdin

  Chaining small tools with pipes and capturing the result with `>` is
  the heart of the Unix way of working, and it's a whole exam objective.

---

  We want to build a list of every login name on the system, sorted and
  with duplicates removed, saved to /root/users.txt. The raw material is
  /etc/passwd, one account per line. Peek at its shape:

```run
head -3 /etc/passwd
```

  Colon-separated fields; the FIRST field is the login name. That's all
  we want from each line.

---

WHY IT MATTERS

  You'll assemble little pipelines like this constantly — pull a column
  out of a file, sort it, count it, dump it somewhere. Knowing which
  redirection does what (and that `>` clobbers while `>>` appends) saves
  you from destroying a file you meant to add to.

---

HOW TO DO IT

  Three pieces, joined into one pipeline:

    cut -d: -f1   split each line on ":" and keep field 1 (the name)
    sort -u       sort the names and drop duplicates (-u = unique)
    > file        write the final result to the file

  cut's stdout flows into sort's stdin through the pipe, and sort's
  stdout is redirected into the file. Build and run it:

```run
cut -d: -f1 /etc/passwd | sort -u > /root/users.txt
```

  Nothing prints — that's correct. The output went into the file instead
  of the screen.

---

CHECK IT WORKED

  Look at the file:

```run
cat /root/users.txt
```

  A tidy alphabetical list, one name per line, no repeats. The grader
  builds the same list with the same pipeline and diffs it against your
  file, so as long as you used cut field 1 and sort -u you match exactly.

  Count the lines if you like:

```run
wc -l /root/users.txt
```

---

GOTCHAS

  - `>` overwrites. Run it twice and the file is rebuilt, which is fine
    here — but never point `>` at a file you want to keep the old
    contents of. Use `>>` to add on.
  - `sort -u` sorts AND de-duplicates in one step. `uniq` only collapses
    ADJACENT duplicates, so `sort | uniq` also works, but bare `uniq`
    without sorting first misses duplicates that aren't next to each
    other.
  - The delimiter for cut is `-d:` (a literal colon), and the field is
    `-f1`. Forget `-d:` and cut defaults to TAB, giving you the whole
    line back.
  - Order matters: sort must come before the `>`, or you'd redirect
    cut's raw output and never sort it.
