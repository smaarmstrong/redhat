THE IDEA

  SELinux runs in one of three modes:

    Enforcing    policy is applied — forbidden actions are actually blocked
    Permissive   policy is only logged — nothing is blocked, denials are
                 recorded (useful for troubleshooting)
    Disabled     SELinux is off entirely

  There are two places the mode lives, and this is the crux of the task:

    - The RUNNING mode, in the kernel right now, changed with setenforce.
      This is volatile — it resets on reboot.
    - The BOOT mode, in /etc/selinux/config (the SELINUX= line). This is
      what the system comes up in every time it powers on.

  You can flip between Enforcing and Permissive at runtime instantly, but
  making it stick means editing the config file too.

---

  The setup dropped the box to permissive both ways. Confirm the running
  mode:

```run
getenforce
```

  It says Permissive. And the boot setting:

```run
grep '^SELINUX=' /etc/selinux/config
```

  That reads SELINUX=permissive. Both need to become enforcing.

---

WHY IT MATTERS

  Permissive means SELinux is watching but blocking nothing — fine while
  debugging, a real weakness in production. "Put this box back into
  enforcing and make sure it stays there" is a bread-and-butter hardening
  task, and the exam wants BOTH the now and the after-reboot.

---

HOW TO DO IT

  Step 1 — switch the running mode. setenforce 1 means enforcing, 0 means
  permissive (you can also say the words):

  Note: changing the running SELinux mode and editing
  /etc/selinux/config are privileged, so these commands are prefixed
  with `sudo` — a normal user who's been granted sudo, exactly the
  exam setup. (Reading the mode with `getenforce` needs no sudo.)

```run
sudo setenforce 1
```

  That took effect this instant — but it changed nothing on disk, so on its
  own it would not survive a reboot.

---

  Step 2 — make it the boot mode by editing the config. Set the SELINUX=
  line to enforcing:

```run
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
```

  A note worth remembering: setenforce can only move you BETWEEN enforcing
  and permissive. It cannot switch a system into or out of Disabled — that
  transition needs a config edit and a reboot (and on RHEL 9 fully
  disabling is done at the kernel command line). For enforcing/permissive,
  the config file is what the next boot reads.

---

CHECK IT WORKED

  Running mode:

```run
getenforce
```

  Should now print Enforcing. And the persistent setting:

```run
grep '^SELINUX=' /etc/selinux/config
```

  Should read exactly SELINUX=enforcing. The grader checks both — getenforce
  for the live mode and /etc/selinux/config for the boot mode — so a
  half-done change (one but not the other) fails.

---

GOTCHAS

  - setenforce alone is runtime-only. Edit /etc/selinux/config or the next
    reboot reverts to permissive.
  - Editing the config alone leaves the box permissive until it reboots;
    the grader checks the live mode too, so do both.
  - Don't confuse the mode line (SELINUX=) with the policy-type line
    (SELINUXTYPE=). You only touch SELINUX= here.
  - If the box were currently Disabled, setenforce would error out — you'd
    fix the config and reboot. Going permissive-to-enforcing (our case) is
    the easy direction.
