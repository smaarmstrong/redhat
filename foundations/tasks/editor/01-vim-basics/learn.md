THE IDEA

  Sooner or later every Linux task ends the same way: "open that file and
  change it". On a server there is no graphical editor — you edit in the
  terminal, and the editor that is ALWAYS there is vi (usually the modern
  build of it, vim; the two names run the same editor here, and everything
  below works in both).

  vi has one big idea that trips everyone up on day one, so let's meet it
  before touching anything: it is a MODAL editor. It has two main modes:

    NORMAL mode   keys are COMMANDS (move, delete, search). Typing "x"
                  deletes a character — it does not type an x. This is
                  the mode vi starts in.

    INSERT mode   keys type text, like a normal editor. You enter it
                  with  i  and leave it with  Esc .

  Almost every "vi is broken!" moment is just being in the wrong mode.
  The fix is always the same: press Esc (once or twice) — that returns
  you to NORMAL mode from anywhere.

---

  Here's the file you'll practise on. Look at it first:

```run
cat /opt/found/notes/journal.txt
```

  Two jobs: the word MONTHLY on the last line should be "weekly", and the
  file needs a new final line saying "Reviewed and approved." — both edits
  made inside vi.

---

WHY IT MATTERS

  The RHCSA exam is, to a large extent, editing text files over SSH:
  /etc/fstab, /etc/default/grub, sudoers drop-ins, config after config.
  You need ONE editor you can trust your fingers with. vi is on every
  machine you'll ever SSH into, including minimal installs and rescue
  environments, so it's the one worth learning.

  (nano is a friendlier editor that's also usually installed — its help
  is printed at the bottom of the screen: Ctrl-O Enter saves, Ctrl-X
  quits. It's fine to use on the exam. But learn the vi survival set
  anyway: one day nano won't be there, and vi will.)

---

THE SURVIVAL SET

  You can do 90% of admin editing with these. Read them now — the next
  step opens vi for real and you'll want them fresh:

    Arrow keys      move the cursor (works in both modes)
    i               enter INSERT mode (start typing at the cursor)
    Esc             leave INSERT mode, back to NORMAL mode
    x               (normal mode) delete the character under the cursor
    cw              (normal mode) "change word" — deletes from the cursor
                    to the end of the word and drops you in INSERT mode
    o               (normal mode) open a new line BELOW and start typing
    G               (normal mode) jump to the last line
    /text  Enter    search forward for "text";  n  jumps to the next hit
    u               (normal mode) undo the last change (press again for more)
    :wq  Enter      write (save) the file and quit
    :q!  Enter      quit WITHOUT saving — the escape hatch

  Everything that starts with ":" is typed in NORMAL mode; it appears in
  the bottom-left of the screen as you type it.

---

FIRST EDIT — change a word

  Plan before we open it: search for the word, change it, save.

    1. Type  /MONTHLY  and press Enter — the cursor jumps onto the word.
    2. Type  cw  ("change word") — MONTHLY vanishes and you're in
       INSERT mode.
    3. Type  weekly  then press  Esc .
    4. Type  :wq  and press Enter — saved, and you're back at the shell.

  If anything goes sideways: press Esc, type  :q!  and Enter — that
  abandons the edit, and you can simply start again. Off you go:

```run
vi /opt/found/notes/journal.txt
```

  (Choosing "t to type it yourself" is ideal here — but Enter works too:
  vi opens in your terminal either way.)

---

  Back at the shell. Check the edit landed:

```run
grep -n "weekly" /opt/found/notes/journal.txt
```

  You should see the disk-usage line, now reading "checked weekly."
  (grep prints matching lines; -n adds the line number. If it printed
  nothing, reopen the file and try the four steps again.)

---

SECOND EDIT — add a line at the end

  This time: jump to the bottom, open a new line, type, save.

    1. Press  G  (capital G — jump to the last line).
    2. Press  o  — a new empty line opens below it and you're already
       in INSERT mode.
    3. Type exactly:  Reviewed and approved.
    4. Press  Esc , then type  :wq  and press Enter.

```run
vi /opt/found/notes/journal.txt
```

---

CHECK IT WORKED

  Print the whole file:

```run
cat /opt/found/notes/journal.txt
```

  Six lines: the four originals untouched, "weekly" in place of MONTHLY,
  and "Reviewed and approved." at the bottom — exactly what the grader
  looks for.

---

GOTCHAS

  - Stuck in vi? Esc, then  :q!  Enter — leaves without saving, always.
    (If you accidentally typed text into the file first, :q! discards it.)
  - Typing commands but letters appear in the file? You're in INSERT
    mode. Esc first, then the command.
  - Commands "not working" and the screen beeping? Check Caps Lock —
    vi commands are case-sensitive (G and g are different).
  - Editing system files like /etc/fstab needs root: open them with
    sudo vi <file>. If you forgot sudo, vi warns the file is read-only
    when you try to save — :q! out and reopen with sudo.
  - "Swap file already exists" when opening? A previous vi on this file
    crashed or is still open elsewhere. Press  q  to quit, close the
    other session (or delete the .swp file it names), and reopen.
  - Undo is  u  in normal mode — not Ctrl-Z, which SUSPENDS vi back to
    the shell. If you did press Ctrl-Z, type  fg  to get vi back.
