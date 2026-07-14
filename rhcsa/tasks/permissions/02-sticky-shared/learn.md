THE IDEA

  A "drop box" directory is one where everybody can create files, but nobody
  can delete or rename someone else's. The classic example is /tmp. Two
  things combine to make that work:

    - World-writable: owner, group, and other all get rwx, so anyone can
      add files.
    - The sticky bit: normally, write permission on a DIRECTORY lets you
      delete ANY file in it, even files you don't own. The sticky bit
      changes that rule — with it set, you can only remove or rename a file
      if you own the file (or the directory, or you're root).

  The target mode is 1777. Reading the octal:

    1   the leading digit — the sticky bit
    7   owner: rwx
    7   group: rwx
    7   other: rwx

---

  The directory doesn't exist yet. Let's peek at /tmp first, since it's the
  living example of exactly this mode:

```run
ls -ld /tmp
```

  See the trailing t in drwxrwxrwt? That t is the sticky bit. We're going to
  reproduce that on a new directory.

---

WHY IT MATTERS

  Any shared upload or spool area needs this pattern, or users trample each
  other's files. "Make a world-writable directory that behaves like /tmp" is
  a standard exam task precisely because world-writable WITHOUT the sticky
  bit is a real security hole — anyone could wipe anyone's files.

---

HOW TO DO IT

  Create the directory:

```run
sudo mkdir -p /srv/dropbox
```

  Now set mode 1777 in one octal step — the leading 1 is the sticky bit,
  the 777 is rwx for everyone:

```run
sudo chmod 1777 /srv/dropbox
```

  Symbolic notation works too: `chmod 777 /srv/dropbox` then
  `chmod +t /srv/dropbox` reaches the same result (+t adds the sticky bit).
  The octal 1777 just does both at once.

---

CHECK IT WORKED

  Long listing:

```run
ls -ld /srv/dropbox
```

  You want drwxrwxrwt — the final t is the sticky bit sitting in the
  "other" execute slot. And the numeric mode the grader reads:

```run
stat -c '%a' /srv/dropbox
```

  That prints 1777. Done.

---

GOTCHAS

  - The leading 1 is the sticky bit. Plain 777 is world-writable but has NO
    protection — anyone could delete anyone's files, and the grader's "1777"
    check fails.
  - Lowercase t in ls means sticky + execute-for-other is on (what you
    want); an uppercase T would mean sticky set but execute-for-other off.
  - Don't mix up the leading digits: 1 = sticky, 2 = set-GID (last lesson),
    4 = set-UID. Only the sticky bit is wanted here.
