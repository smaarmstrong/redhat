THE IDEA

  sudo lets an ordinary user run commands as root, governed by the rules in
  /etc/sudoers (and the drop-in files under /etc/sudoers.d/). On RHEL and
  Rocky there's a shortcut built into that config: anyone in the group
  wheel automatically gets full sudo. So there are two clean ways to grant
  "run any command":

    1. Add the user to the wheel group (uses the rule that ships by
       default), OR
    2. Drop a small validated file in /etc/sudoers.d/ granting them ALL.

  Either satisfies this task. We'll do the wheel approach as the main path
  and show the drop-in file as the alternative.

---

  Note: creating an account and reading the root-only /etc/sudoers
  file both need privilege, so those commands are prefixed with
  `sudo` — a normal user who's been granted sudo, exactly the exam
  setup.

  First create the admin account the task asks for, opsadmin:

```run
sudo useradd opsadmin
```

  And confirm the default wheel rule is present in the main sudoers file —
  this is the line that makes wheel membership meaningful:

```run
sudo grep -E '^\s*%wheel' /etc/sudoers
```

  You'll see: %wheel ALL=(ALL) ALL. The % means "group", so every member of
  wheel may run any command as anyone.

---

WHY IT MATTERS

  Delegating admin rights safely — without handing out the root password —
  is a core RHCSA skill and a daily real-world one. The exam wants the grant
  to PERSIST and to be done cleanly. Editing sudoers wrongly can lock
  everyone out of root, so knowing the safe, validated way to do it matters.

---

HOW TO DO IT — the wheel way

  Append opsadmin to the wheel group (note -aG, so you don't disturb its
  other groups):

```run
sudo usermod -aG wheel opsadmin
```

  That's the whole grant. Because the %wheel rule already exists, opsadmin
  now has full sudo, and the membership is stored in /etc/group so it
  persists.

---

HOW TO DO IT — the sudoers.d way (alternative)

  If you'd rather not use wheel, create a drop-in rule. The golden rule:
  NEVER edit sudoers files with a plain editor and save blindly — a syntax
  error can break sudo for everyone. Either use `visudo` (which
  syntax-checks before saving) or write the file and then validate it with
  `visudo -cf`. Here's the safe write-then-validate pattern:

    $ echo 'opsadmin ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/opsadmin
    $ sudo chmod 0440 /etc/sudoers.d/opsadmin
    $ sudo visudo -cf /etc/sudoers.d/opsadmin

  The mode 0440 (read-only, owner+group) is what sudo expects; a
  world-writable sudoers file is refused. The visudo -cf check must print
  "parsed OK" before you trust it. (We won't run this here since wheel
  already solved it — but know both paths.)

---

CHECK IT WORKED

  Confirm opsadmin is in wheel:

```run
id -nG opsadmin
```

  wheel should be in that list. That membership (or, on the alternative
  path, a validated /etc/sudoers.d/opsadmin granting ALL) is exactly what
  grade.sh accepts.

---

GOTCHAS

  - usermod -aG wheel — the -a matters as always, or you overwrite the
    user's other groups.
  - Never hand-edit /etc/sudoers with vi directly. Use visudo, or validate
    a drop-in with visudo -cf before relying on it. A broken sudoers can
    lock you out of root entirely.
  - sudoers.d files must be mode 0440 and owned by root; sudo ignores
    (and can complain about) files with the wrong permissions.
  - "wheel" on RHEL/Rocky is the admin group. On some other distros it's
    "sudo" instead — don't carry that habit over here.
