THE IDEA

  Creating an account is useradd; changing an existing one is usermod. It
  edits the same on-disk files — /etc/passwd for the shell, /etc/group for
  supplementary group membership, /etc/shadow for the lock state — so every
  change it makes is permanent without any extra step.

  This task has three separate edits to one user, webadmin:

    1. change the login shell to /sbin/nologin
    2. add webadmin to the supplementary group webteam
    3. lock the account so it can't be used to log in

---

  webadmin already exists (the setup gave it /bin/bash, a password, and no
  membership in webteam). Have a look at where it starts:

```run
getent passwd webadmin
id webadmin
```

  Note the shell is /bin/bash and webteam is NOT in its group list yet.

---

WHY IT MATTERS

  /sbin/nologin is the standard way to say "this account exists but nobody
  logs in as it interactively" — perfect for service accounts. Locking is a
  separate idea: it disables the password so the account can't authenticate,
  without deleting anything. Real admins reach for both constantly, and the
  exam tests that you know they're distinct knobs.

---

HOW TO DO IT — the shell

  Point the login shell at /sbin/nologin:

```run
sudo usermod -s /sbin/nologin webadmin
```

---

HOW TO DO IT — the group

  Here is the single most important flag in this lesson: -aG. The -G option
  sets the supplementary group list, and on its own it REPLACES whatever
  groups the user already had. The -a ("append") says "add to the list,
  don't overwrite it". Always pair them:

```run
sudo usermod -aG webteam webadmin
```

  Forget the -a and you'd silently drop the user out of every other
  supplementary group — a classic way to break an account.

---

HOW TO DO IT — the lock

  Locking a password is -L (uppercase). Under the hood it prepends a ! to
  the password hash in /etc/shadow, which no password can ever match, so
  authentication fails:

```run
sudo usermod -L webadmin
```

  (The opposite is -U, unlock, which strips the ! back off.)

---

CHECK IT WORKED

  Shell and groups first:

```run
getent passwd webadmin | cut -d: -f7
id -nG webadmin
```

  You want /sbin/nologin, and webteam should appear in the group list. Now
  the lock — peek at the second field of the shadow entry (needs root):

```run
sudo getent shadow webadmin | cut -d: -f2
```

  A locked account's hash starts with an exclamation mark. That leading !
  is exactly what grade.sh checks for, alongside the shell and the webteam
  membership.

---

GOTCHAS

  - -aG, always. Bare -G overwrites the group list; the -a keeps existing
    memberships. This is the number-one usermod trap.
  - Case matters: -L locks, -l (lowercase) renames the login. Don't mix
    them up.
  - Locking is not deleting and not "disable shell". You could set nologin
    AND lock — as here — and they do different jobs: nologin blocks the
    interactive shell, the lock blocks password auth.
  - passwd -l / passwd -u do the same lock/unlock as usermod -L / -U; both
    are fine on the exam.
