THE IDEA

  The manual pages are the offline reference for almost everything on the
  system, and there are two ways in:

    man command    read the full page for a command you already know
    apropos word   SEARCH every page's one-line description for a
                   keyword, and list the pages that mention it

  `apropos word` is identical to `man -k word`. It's how you find the
  command you can't quite name: "there's something for passwords... what
  is it?" apropos password lists them all, each with its section number
  and short description.

  apropos reads a keyword index (a cache) that man-db builds with
  `mandb`. No cache, no results — so the index has to exist first.

---

  Try the search and see what comes back:

```run
apropos password
```

  A list of commands — passwd, chage, gpasswd, and more — each with the
  section in parentheses and a short description that contains the word
  "password".

---

WHY IT MATTERS

  In the exam you have no internet — the man pages ARE your
  documentation. Being able to keyword-search when you don't know the
  exact command name is genuinely exam-saving, and it's a listed
  objective: locate and use system documentation via man, info, and
  /usr/share/doc. In real life it's the fastest way to discover tooling
  you didn't know was installed.

---

HOW TO DO IT

  The task just wants the FULL output of that search saved to a file.
  Redirect apropos into /root/pw-cmds.txt:

```run
apropos password > /root/pw-cmds.txt
```

  That's it — one command, one redirect. If apropos ever returns
  nothing, the keyword cache hasn't been built; you'd fix that once with
  `sudo mandb` and re-run. (The task setup already builds it for you.)

---

CHECK IT WORKED

  Look at the saved file:

```run
cat /root/pw-cmds.txt
```

  It holds exactly what apropos printed to the screen a moment ago. The
  grader runs `apropos password` itself and compares its output to your
  file byte-for-byte, so a straight redirect matches.

  Count how many commands matched:

```run
wc -l /root/pw-cmds.txt
```

---

GOTCHAS

  - Save the WHOLE output, not a filtered slice. Don't pipe through grep
    or head — the grader wants the complete apropos listing.
  - `apropos password` equals `man -k password`; either produces the same
    lines, so either would pass.
  - If apropos says "nothing appropriate", the man-db index isn't built.
    Run `sudo mandb` once to build it, then redirect again. (First build
    can be slow.)
  - `>` overwrites the file each run, which is what you want here — a
    fresh, exact capture every time.
