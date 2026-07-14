THE IDEA

  The bread and butter of working at a shell: making directories,
  copying files, creating empty ones. Four commands cover almost
  everything:

    mkdir   make a directory (add -p to make parents / whole trees)
    cp      copy a file (SOURCE then DESTINATION)
    mv      move or rename
    touch   create an empty file (or update a timestamp)

  This task builds a small project tree with three of them.

---

  Nothing exists yet under /srv/proj — we start from a clean slate.
  We want to end up with:

    /srv/proj/src/main.sh          (empty file)
    /srv/proj/bin/                 (empty directory)
    /srv/proj/docs/hostname.txt    (a copy of /etc/hostname)

---

WHY IT MATTERS

  Every install, deploy, or bit of admin scaffolding starts with laying
  out directories and dropping files in the right place. It's basic, but
  the exam expects it to be automatic and error-free, and small slips
  (wrong cp direction, forgetting -p) waste time you don't have.

---

HOW TO DO IT

  First the three directories. `mkdir -p` creates parent directories as
  needed AND lets you list several at once, so /srv/proj itself and all
  three subdirs appear in one command:

```run
mkdir -p /srv/proj/src /srv/proj/bin /srv/proj/docs
```

  Now copy /etc/hostname into docs under a new name. cp takes SOURCE
  first, DESTINATION second; naming the destination file gives it the
  new name in one go:

```run
cp /etc/hostname /srv/proj/docs/hostname.txt
```

  Finally an empty file for the source directory. `touch` creates it with
  zero bytes:

```run
touch /srv/proj/src/main.sh
```

---

CHECK IT WORKED

  See the whole tree at once:

```run
ls -lR /srv/proj
```

  Three directories, main.sh as an empty (0-byte) regular file, and
  hostname.txt in docs. The grader checks each directory exists, that
  main.sh and hostname.txt are regular files, and — importantly — that
  hostname.txt's content matches /etc/hostname. Confirm that copy:

```run
diff /etc/hostname /srv/proj/docs/hostname.txt && echo "identical"
```

  No output from diff (then "identical") means they match.

---

GOTCHAS

  - cp direction is SOURCE then DEST. `cp /srv/proj/docs/hostname.txt
    /etc/hostname` would go the wrong way and overwrite the real file.
  - -p on mkdir means "make parents, no error if it already exists". It
    is not the same as -p on cp (which preserves permissions). Same
    letter, different tools.
  - The copy must be a real copy with matching content — a symlink or an
    empty touch'd file would fail the content check.
  - touch on an existing file just updates its timestamp; here the file
    doesn't exist yet, so it's created empty. That's what's wanted.
