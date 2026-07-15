THE IDEA

  Every command you run has three "hoses" attached to it:

    stdin    (0)  what it reads — normally your keyboard
    stdout   (1)  what it prints — normally your screen
    stderr   (2)  its error messages — ALSO your screen, but a
                  separate hose

  The shell can re-plug those hoses before the command starts. That one
  trick — redirection — is what turns single commands into plumbing:

    command  > file     send stdout into file (create/overwrite it)
    command >> file     append stdout to the end of file
    command 2> file     send stderr into file
    command  < file     read stdin from file
    cmd1 | cmd2         a PIPE: cmd1's stdout becomes cmd2's stdin

  The command itself doesn't know or care — `sort` behaves identically
  whether its output goes to your eyes or into a file.

---

  Here's the data we'll plumb around — a tiny order log with duplicates:

```run
cat /opt/found/shop/orders.txt
```

  (`cat` prints a file's contents to stdout — which is your screen,
  because we haven't redirected anything yet.)

---

WHY IT MATTERS

  Redirection is the connective tissue of everything an admin does:
  saving a report to a file, appending to a log, keeping error output
  separate, feeding one command's output into the next. The exam lists
  "use input-output redirection (>, >>, |, 2>, etc.)" as an objective of
  its own — and nearly every OTHER task quietly depends on it.

---

SEND OUTPUT TO A FILE:  >

  `sort` reads lines and prints them in order. On its own, to the screen:

```run
sort /opt/found/shop/orders.txt
```

  Same lines, alphabetised. Now re-plug stdout into a file with `>`:

```run
sort /opt/found/shop/orders.txt > /opt/found/shop/sorted.txt
cat /opt/found/shop/sorted.txt
```

  Nothing appeared after the first command — the output went into
  sorted.txt instead of the screen, which is exactly the point. The
  `cat` proves it landed. One warning to tattoo somewhere:  >  CREATES
  the file if missing and OVERWRITES it completely if it exists.

---

APPEND:  >>

  Two angle brackets add to the end instead of overwriting:

```run
echo "first line"  > /opt/found/shop/demo.txt
echo "second line" >> /opt/found/shop/demo.txt
echo "third line"  >> /opt/found/shop/demo.txt
cat /opt/found/shop/demo.txt
```

  The first `>` started the file fresh; each `>>` stacked a line on.
  (Had we used `>` all three times, only "third line" would survive.)

---

PIPES:  |

  A pipe hands one command's stdout to the next command's stdin — no
  temporary file needed. `uniq` collapses ADJACENT duplicate lines,
  which is why it's almost always fed by sort:

```run
sort /opt/found/shop/orders.txt | uniq
```

  Read it left to right: sort's output flows into uniq. Each product
  once. Pipes chain as far as you like — add `wc -l` (word count,
  -l = count lines) to count the distinct products:

```run
sort /opt/found/shop/orders.txt | uniq | wc -l
```

  And a pipe's end can still be redirected into a file:

```run
sort /opt/found/shop/orders.txt | uniq > /opt/found/shop/unique.txt
cat /opt/found/shop/unique.txt
```

  (`sort -u` does sort-and-dedupe in one; both spellings are fine.)

---

READ FROM A FILE:  <

  A subtle one. Compare:

```run
wc -l /opt/found/shop/orders.txt
wc -l < /opt/found/shop/orders.txt
```

  Given a filename ARGUMENT, wc prints the count AND the name. Fed the
  file on stdin with `<`, wc never sees a filename — so it prints just
  the number. Handy when you want the bare value in a file or variable.

---

ERRORS ARE A SEPARATE HOSE:  2>

  Ask ls for a file that doesn't exist:

```run
ls /opt/found/shop/nothing-here
```

  That complaint came out of stderr, not stdout. Redirect stdout and
  it STILL reaches your screen — which is the feature: pipes and `>`
  capture results, while errors stay visible. To capture the errors
  themselves, redirect hose number 2:

```run
ls /opt/found/shop/nothing-here 2> /opt/found/shop/errors.txt
cat /opt/found/shop/errors.txt
```

  Silence on the first line — the error went into the file. (To send
  BOTH hoses to one file:  command > file 2>&1  — "and point 2 where
  1 points". You'll meet it in scripts constantly.)

---

CHECK IT WORKED

  The graded task asks for sorted.txt, unique.txt, count.txt and
  errors.txt built exactly these ways. You've already made three of
  them while following along; the solo run afterwards starts clean, so
  you'll rebuild them all. Survey the directory:

```run
ls -l /opt/found/shop
```

---

GOTCHAS

  - `>` overwrites without asking. On a file you care about, that IS
    the data-loss story. When adding, mean `>>`.
  - Redirections belong at the end of the command they modify:
    `sort file > out`, not `sort > out file` (legal, but confusing).
  - A pipe carries stdout only — error messages skip past the pipe to
    your screen. That's why `2>` exists.
  - Order matters in `> file 2>&1`: it reads "stdout to file, THEN
    stderr to where stdout now points". Reversed (`2>&1 > file`),
    stderr still hits the screen.
  - Writing to root-owned places (like /etc/motd) with sudo has a trap:
    in `sudo cmd > file` the REDIRECTION is done by your unprivileged
    shell, so it fails. The fix is `sudo sh -c 'cmd > file'`. The
    practice dir here is world-writable precisely so you can ignore
    that today — but it's waiting for you in the exam tasks.
