THE IDEA

  A "collaborative directory" is a folder a whole team can work in, where
  every file they create automatically belongs to the shared group so the
  others can get at it. Two ingredients make that happen:

    1. The directory is group-owned by the team's group, with rwx for that
       group.
    2. The set-GID bit is on. Normally a new file takes its creator's
       primary group; with set-GID on the parent directory, new files
       instead INHERIT the directory's group. That's the magic that keeps
       everything readable by the team.

  The target mode is 2770. Reading that octal left to right:

    2   the leading digit — the set-GID special bit
    7   owner: rwx
    7   group: rwx
    0   other: no access at all

---

  Nothing exists yet — no group, no directory. Let's build it. First the
  team's group:

```run
sudo groupadd developers
```

---

WHY IT MATTERS

  Shared project directories are one of the most common real admin requests,
  and set-GID is the exact trick that makes them work without everyone
  fiddling with `chgrp` on every file. The exam tests set-GID specifically
  because people forget it and then wonder why teammates can't read each
  other's files.

---

HOW TO DO IT — create and assign

  Make the directory and give it to the developers group:

```run
sudo mkdir -p /srv/devshare
sudo chgrp developers /srv/devshare
```

  chgrp changes only the GROUP owner, leaving the user owner (root) alone —
  which is what we want.

---

HOW TO DO IT — set the mode

  Now set mode 2770. You can do it in octal, which sets everything at once:

```run
sudo chmod 2770 /srv/devshare
```

  If you prefer symbolic notation, `chmod g+s` sets just the set-GID bit and
  `chmod 770` sets the rwx part — `chmod g+s /srv/devshare` after a
  `chmod 770` gets you to the same place. The octal 2770 does both in one
  step; the leading 2 IS the set-GID bit.

---

CHECK IT WORKED

  Look at the long listing:

```run
ls -ld /srv/devshare
```

  You should see drwxrws--- : the s in the group's execute slot is the
  set-GID bit showing up. Confirm the exact numeric mode and group the
  grader reads:

```run
stat -c '%a %G' /srv/devshare
```

  That prints "2770 developers" — the mode and group owner grade.sh checks.

---

GOTCHAS

  - The leading 2 in 2770 is set-GID. Plain 770 would give correct rwx but
    NO group inheritance, so the grader's "2770" check fails. Don't drop it.
  - In `ls`, a lowercase s in the group execute column means set-GID with
    execute on; an uppercase S would mean set-GID set but execute OFF (you'd
    have used 2760 or similar) — you want the lowercase s here.
  - Don't confuse set-GID (2, group inheritance) with set-UID (4, run as
    file owner) or the sticky bit (1, the next lesson). Different leading
    digits, different jobs.
  - "other" is 0 on purpose — outsiders get nothing. Don't accidentally
    grant them read.
