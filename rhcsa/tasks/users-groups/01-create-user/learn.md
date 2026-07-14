THE IDEA

  A local user account is really just a line in /etc/passwd plus a
  matching line in /etc/shadow. The line in /etc/passwd records the
  username, a numeric UID, the primary group's GID, a comment field
  (historically called GECOS), the home directory, and the login shell:

    dbuser:x:1500:1500:Database User:/home/dbuser:/bin/bash

  You almost never edit that file by hand. One command, useradd, creates
  the account and fills in all those fields — and because it writes them to
  disk, the account is permanent by nature.

---

  This task asks for a very specific account: username dbuser, UID exactly
  1500, comment "Database User", and shell /bin/bash. The starting system
  has no such user yet. Let's confirm that:

```run
getent passwd dbuser
```

  No output and a non-zero exit means the account doesn't exist. Good — a
  clean slate to build on.

---

WHY IT MATTERS

  Creating accounts with the right attributes is the bread-and-butter of
  user administration, and the exam loves to pin down exact values: a
  specific UID, a specific shell, a specific comment. Miss any one of them
  and the check for that field fails. So the skill isn't just "make a user"
  — it's "make a user with EXACTLY these properties in one go".

---

HOW TO DO IT

  useradd takes an option for each field we care about:

    -u 1500              set the UID to 1500
    -c "Database User"   set the comment / GECOS field
    -s /bin/bash         set the login shell

  Run the whole thing at once:

```run
sudo useradd -u 1500 -c "Database User" -s /bin/bash dbuser
```

  No output means success (Unix tools stay quiet when happy). The username
  goes last, after all the options. By default useradd also creates a home
  directory /home/dbuser and a primary group named dbuser with the same GID
  — you didn't have to ask for those.

---

CHECK IT WORKED

  Look at the passwd entry you just created:

```run
getent passwd dbuser
```

  You should see dbuser, then x, then 1500, and further along "Database
  User" and /bin/bash. Two quick spot-checks on the fields the grader cares
  about:

```run
id -u dbuser
getent passwd dbuser | cut -d: -f5,7
```

  That prints the UID on its own, then the comment and shell. All four
  target values — user exists, UID 1500, comment, shell — are what
  grade.sh reads straight out of /etc/passwd.

---

GOTCHAS

  - Options come BEFORE the username. `useradd dbuser -u 1500` is a common
    fumble; keep the name last.
  - If a half-finished dbuser already existed, useradd would refuse with
    "user already exists". Fix it with `userdel -r dbuser` and retry, or
    adjust the existing account with usermod (the next lesson).
  - -c takes free text, so quote it: "Database User" is one field, not two.
  - Don't confuse -u (numeric UID) with -c (comment). Getting the UID
    exactly 1500 is a graded field.
