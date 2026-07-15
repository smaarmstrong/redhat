THE IDEA

  A file on Linux is really two things: the DATA, plus a directory entry
  (a name) that points at it. The number that ties a name to its data is
  the inode. A "link" is just another name pointing at data — and there
  are two flavours:

    hard link  another name for the SAME inode. The file has two names,
               both equal; neither is "the original". The data survives
               until the LAST name is removed.

    soft link  (symbolic link, symlink) a tiny separate file whose
               contents are a PATH. It points at a name, not an inode.
               If the target is renamed or deleted, the symlink dangles.

---

  Right now /opt/src/original.txt exists and has one name. Let's look at
  it, including its inode number and link count:

```run
ls -li /opt/src/original.txt
```

  The first number is the inode; the number after the permissions (the
  "2" or "1") is the link count — how many names point at this inode.
  It should say 1 for now.

---

WHY IT MATTERS

  Hard and soft links are everywhere on a real system: /usr/bin is full
  of symlinks, log rotation relies on link behaviour, and the exam lists
  "create hard and soft links" as its own objective. Knowing which one
  survives a rename or a delete — and how to tell them apart with ls —
  is the whole skill.

  These links live on disk, so creating them once is permanent; they
  come back automatically after a reboot.

---

HOW TO DO IT

  One command makes both. `ln` with no options makes a HARD link;
  `ln -s` makes a SYMBOLIC one. The order is always ln TARGET LINKNAME.

  One practical thing first: /opt/src is owned by root, and you're a
  normal user. Writing there needs elevated rights, so we prefix each
  command with `sudo` — you're a normal user who's been granted sudo,
  exactly the situation on the exam. (Reading the directory needs no
  sudo, which is why the `ls` steps above didn't use it.)

  First the hard link — same inode as original.txt:

```run
sudo ln /opt/src/original.txt /opt/src/hardlink.txt
```

  Now the soft link. Notice the target here is just `original.txt`, not
  the full path — a relative symlink resolves against the directory the
  link sits in, so this points at the file right beside it:

```run
sudo ln -s original.txt /opt/src/symlink.txt
```

---

CHECK IT WORKED

  List the directory with inodes again:

```run
ls -li /opt/src
```

  Two things to spot. original.txt and hardlink.txt now share the SAME
  inode number, and the link count on both reads 2 — that is the grader's
  test `hardlink.txt -ef original.txt`. And symlink.txt shows up with an
  `l` at the front of its permissions and an arrow, `symlink.txt ->
  original.txt`.

  Confirm the symlink's stored path directly:

```run
readlink /opt/src/symlink.txt
```

  It prints `original.txt`, which is exactly what the grader checks.

---

GOTCHAS

  - Argument order is ln TARGET LINKNAME. Swap them and you make a link
    with the wrong name (or fail).
  - Don't make the "hard link" a symlink by accident — plain `ln`, no -s.
    The grader explicitly checks hardlink.txt is NOT a symlink.
  - A hard link cannot cross filesystems or point at a directory; a
    symlink can do both. For this task both names live in /opt/src, so
    the hard link is fine.
  - Relative vs absolute symlinks: `ln -s original.txt ...` works because
    both files are in the same directory. `ln -s /opt/src/original.txt
    ...` would also pass here, but relative links survive the directory
    being moved.
