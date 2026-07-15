THE IDEA

  A group is a named bucket of users, stored as one line in /etc/group:

    engineers:x:4000:alice,bob

  That's the group name, an x placeholder, the numeric GID, and a
  comma-separated member list. Groups are how you hand the same permission
  to several people at once — you grant the group access to a file or
  directory, then anyone in the group inherits it.

  Every user also has a PRIMARY group (the GID in their /etc/passwd line)
  plus zero or more SUPPLEMENTARY groups (the extra memberships listed in
  /etc/group). This task only needs supplementary membership.

---

  This task builds three things from nothing: a group engineers with GID
  exactly 4000, two users alice and bob, and membership of both in
  engineers. Confirm the clean slate:

```run
getent group engineers
getent passwd alice bob
```

  No output means none of them exist yet.

---

WHY IT MATTERS

  "Create a group with this GID and put these people in it" is the
  foundation of collaborative access — you'll do exactly this before the
  next lesson's shared directory. The exam typically pins the GID to a
  specific number, so creating the group with the right GID from the start
  is the skill.

---

HOW TO DO IT — the group

  Note: creating groups and accounts needs privilege, so these
  commands are prefixed with `sudo` — a normal user who's been
  granted sudo, exactly the exam setup. (Reading with `getent`/`id`
  needs no sudo.)

  groupadd with -g sets the GID:

```run
sudo groupadd -g 4000 engineers
```

---

HOW TO DO IT — the members

  You can create a user AND set their supplementary groups in one shot with
  useradd -G. Because these users don't exist yet, that's the tidiest path:

```run
sudo useradd -G engineers alice
sudo useradd -G engineers bob
```

  Each gets their own primary group (alice, bob) as usual, PLUS engineers
  as a supplementary group.

  If the users had ALREADY existed, you'd add them instead with
  usermod -aG engineers alice — remember the -a from the last lesson so you
  don't wipe their other groups. Same idea, different starting point.

---

CHECK IT WORKED

  Look at the group line and its GID:

```run
getent group engineers
```

  You should see gid 4000 and both names in the member list. Then confirm
  from each user's side:

```run
id -nG alice
id -nG bob
```

  engineers should appear in both. Those two views — the GID in /etc/group
  and each user's group list — are what grade.sh inspects.

---

GOTCHAS

  - -g (lowercase) on groupadd sets the GID number; don't confuse it with
    useradd's -G, which sets a user's supplementary GROUPS. Same letter,
    different tools, different meaning.
  - For an EXISTING user, use usermod -aG (append). Bare -G replaces the
    list — the recurring trap.
  - Supplementary membership added while a user is logged in doesn't affect
    their current shell; it takes effect on their next login (or `newgrp`).
    On the exam that's fine — the files on disk are what's graded.
