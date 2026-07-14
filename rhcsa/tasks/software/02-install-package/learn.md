THE IDEA

  Software on RHEL/Rocky ships as RPM packages, and dnf is the tool that
  installs them — resolving dependencies, pulling everything from your
  configured repositories, and recording what it did. The single most
  common thing you'll ever type as a sysadmin is:

    dnf install <package>

  dnf figures out which repo has the package, downloads it plus anything it
  depends on, and installs the lot.

---

  Before installing, it's worth seeing how you'd even find a package. Run:

```run
dnf list tree 2>/dev/null
```

  That shows whether `tree` is available in a repo, already installed, or
  both. Right now it should show up as available (setup made sure it's not
  installed yet, so there's real work to do).

---

WHY IT MATTERS

  "Install and update software packages" is a core objective, and it's the
  most literal exam task there is: they name a package, you install it. The
  only thing that can go wrong is not having a working repository — which is
  why the previous task (configure a repo) comes first. With a good repo in
  place, installing is one command.

  An installed RPM stays installed across reboots — there's nothing to
  persist by hand.

---

HOW TO DO IT

  Install the package. The -y answers "yes" to the confirmation prompt so
  it runs unattended:

```run
sudo dnf -y install tree
```

  Watch the output: dnf lists what it will install (tree plus any
  dependencies), downloads the RPMs, then installs and prints "Complete!".
  If tree pulls in nothing extra, you'll just see the one package.

---

CHECK IT WORKED

  The grader checks exactly one thing — that the RPM is present — using rpm,
  the low-level database query tool. Do the same:

```run
rpm -q tree
```

  That prints the full package name and version (e.g.
  tree-1.8.0-...el9.x86_64). If instead you see "package tree is not
  installed", something went wrong upstream (usually no enabled repo).

  And since it's now a real command, you can just use it:

```run
tree -L 1 /etc
```

---

GOTCHAS

  - No repo, no install. If dnf can't reach any enabled repository it will
    fail with nothing to install from. Configure the DVD/BaseOS repo first
    (that's the software/01 task).
  - Verify with `rpm -q`, not by "does the command run" — some packages
    install files, config, or libraries with no matching command name.
  - `dnf install` is idempotent: running it again on an
    already-installed package just says "Nothing to do" — it won't reinstall
    or complain.
