THE IDEA

  Creating a text file with EXACT content is a core skill. "Exact" is the
  operative word: the right lines, in the right order, no stray blank
  lines, no trailing spaces, and each line ending in a proper newline.
  Editors like vi/nano do this, but for scripted, precise content the
  cleanest tool is `printf`, where you control every character including
  the newlines (\n).

  Here the file is /etc/motd — the "message of the day" printed to users
  when they log in — and it must contain exactly two lines:

    Authorized access only.
    Contact ops@example.com

---

  Right now the file is blank (setup emptied it). Confirm:

```run
cat /etc/motd; echo "---end---"
```

  Nothing but the ---end--- marker — an empty file. We'll fill it.

---

WHY IT MATTERS

  Lots of exam tasks boil down to "put exactly this text in exactly this
  file" — a login banner, a config directive, a hosts entry. Graders
  compare byte-for-byte, so an extra blank line or a missing final
  newline is the difference between pass and fail. /etc/motd is also a
  real-world thing: legal login banners are a common security
  requirement.

---

HOW TO DO IT

  printf takes a format string and prints it literally, interpreting
  backslash escapes. `\n` is a newline. So two lines each followed by \n
  gives exactly the required file. Redirect it with `>` into /etc/motd
  (you need root to write under /etc):

```run
sudo sh -c "printf 'Authorized access only.\nContact ops@example.com\n' > /etc/motd"
```

  We wrap it in `sudo sh -c '...'` so the redirection also happens as
  root — otherwise the shell tries to open /etc/motd as your normal user
  before sudo runs.

  Note the trailing \n after the second line: it puts a newline at the
  end of the last line, the normal convention for text files.

---

CHECK IT WORKED

  Print it back:

```run
cat /etc/motd
```

  Exactly the two lines, nothing extra. The grader compares the file
  against the same two-line string, so this matches. A precise way to
  see there are no hidden characters is cat -A, which shows line ends as
  $ and tabs as ^I:

```run
cat -A /etc/motd
```

  You want a `$` at the end of each of the two lines and no other junk.

---

GOTCHAS

  - `echo` behaves differently across shells for backslashes; printf is
    predictable. If you do use echo, `echo -e` is needed for \n, and it's
    less portable. printf is the safe habit.
  - Watch the final newline. Ending with \n gives the proper trailing
    newline the grader expects; leaving it off can cause a mismatch.
  - No extra blank lines and no leading spaces. Copy-pasting into an
    editor sometimes adds a stray blank line at the top or bottom — this
    grader rejects that.
  - Redirect as root. `sudo printf ... > /etc/motd` fails because the
    shell opens the file as you, before sudo; use `sudo sh -c '... >
    /etc/motd'` (or edit with `sudo vi`).
