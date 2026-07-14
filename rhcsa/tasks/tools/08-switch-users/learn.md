THE IDEA

  You don't stay root all day — you switch INTO an account, do work as
  that user, then switch back. `su` ("substitute user") is the classic
  tool. Two forms matter:

    su operator      become operator, but KEEP the old environment and
                     stay in the current directory
    su - operator    a LOGIN switch: run operator's login scripts, land
                     in operator's home, get operator's PATH and shell —
                     as if operator had just logged in

  The dash makes all the difference: `su -` gives you a clean, correct
  environment for that user. Use it.

  You can also run a single command as the user without an interactive
  shell: `su - operator -c 'some command'`.

---

  The account already exists. Confirm it and see its home directory:

```run
getent passwd operator
```

  The sixth colon-separated field is the home directory,
  /home/operator — that's where our file needs to land.

---

WHY IT MATTERS

  Running as the right user is fundamental: files get created owned by
  whoever creates them, and "who owns this" drives all of Linux
  permissions. Doing work as root that should be done as a user leaves
  root-owned files in someone's home that they then can't manage. The
  exam objective is exactly "log in and switch users in multi-user
  targets", and su is how you do it from a text console.

---

HOW TO DO IT

  We're root now. We want a file created BY operator so it's OWNED by
  operator. The tidy one-shot way is `su - operator -c '...'`: it becomes
  operator, runs the touch, and returns:

```run
sudo su - operator -c 'touch /home/operator/created-by-me.txt'
```

  Because operator ran the touch, the new file is owned by operator
  automatically — no chown needed.

  (Interactively you'd type `su - operator`, get operator's prompt, run
  `touch ~/created-by-me.txt`, then `exit` back to root. The -c form just
  does that in one line.)

---

CHECK IT WORKED

  Check the file and, crucially, its owner:

```run
ls -l /home/operator/created-by-me.txt
```

  The owner column should read `operator operator`. The grader checks
  three things: the file exists, its owner (via stat) is operator, and
  it sits in operator's home directory. Confirm ownership directly:

```run
stat -c '%U' /home/operator/created-by-me.txt
```

  It prints `operator`.

---

GOTCHAS

  - Ownership is the real test. If you created the file as root (plain
    `touch /home/operator/...`) it would be owned by root and FAIL —
    even though it's in the right place. It must be created AS operator
    (or chown'd to operator afterwards).
  - `su -` vs `su`: the dash gives operator's full login environment and
    home directory. Without it you keep root's environment, which can put
    you in the wrong directory or with the wrong PATH.
  - `su -c` runs one command then returns; you don't get stuck in a
    subshell. Handy for scripted, single-step actions like this.
  - The file may be empty — content doesn't matter, ownership does.
