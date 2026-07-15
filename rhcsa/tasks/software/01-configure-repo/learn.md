THE IDEA

  dnf (the RHEL/Rocky package manager) doesn't magically know where
  packages come from. It reads a set of "repository definitions" — small
  INI-style text files under /etc/yum.repos.d/, each ending in .repo. Every
  file can describe one or more repositories, and each repository is a
  bracketed section: an id in [square brackets] followed by key=value lines.

  The two keys that actually locate the packages are:

    baseurl   where the repo lives — a URL. It can be http(s)://... on a
              network mirror, or file://... for a directory on this machine
              (like a mounted install DVD).
    enabled   1 means dnf uses it; 0 means ignore it.

---

  Let's look at what's already here. Run:

```run
ls /etc/yum.repos.d/
```

  Each of those .repo files is just plain text you can read and write. Take
  a peek inside one to see the shape of a repository stanza:

```run
head -n 20 /etc/yum.repos.d/*.repo | head -n 25
```

  Notice the pattern: a [section-id] line, then name=, baseurl= (or a
  mirrorlist), enabled=, gpgcheck=. That's all we're going to create.

---

WHY IT MATTERS

  On the exam — and on a real box with no internet — you often only have
  the installation DVD. Mount it and point a repo file at it, and suddenly
  dnf can install anything from BaseOS. "Configure access to RPM
  repositories" is a stated objective, and hand-writing a .repo file is the
  bread-and-butter way to do it.

  Because it's an ordinary file, it persists across reboots automatically —
  there's no service to enable.

---

HOW TO DO IT

  We want a file /etc/yum.repos.d/local.repo describing a repo with id
  localdvd, pointing at file:///mnt/dvd/BaseOS, enabled, with GPG checking
  off (the DVD contents are trusted, and we're not verifying signatures
  here).

  The cleanest way to write a multi-line config file is a "here-document" —
  cat writing everything between the markers straight into the file. Run:

  Note: /etc/yum.repos.d is owned by root and you're a normal user,
  so the command that writes the repo file there is prefixed with
  `sudo` — a normal user who's been granted sudo, exactly the exam
  setup. (Reading the existing .repo files needs no sudo, which is
  why the earlier `ls`/`head` didn't.)

```run
sudo tee /etc/yum.repos.d/local.repo > /dev/null <<'EOF'
[localdvd]
name=Local DVD BaseOS
baseurl=file:///mnt/dvd/BaseOS
enabled=1
gpgcheck=0
EOF
```

  A few notes on what each line does:

    [localdvd]   the repo id — this is the identifier dnf uses and exactly
                 what the grader looks for.
    name=        a free-text human label; any description is fine.
    baseurl=     three slashes: file:// is the scheme, then the absolute
                 path /mnt/dvd/BaseOS. That directory need not exist for
                 this task — only the definition is graded.
    enabled=1    dnf will consult this repo.
    gpgcheck=0   don't require signed packages.

  (On a real DVD you'd first mount it, e.g.
   `sudo mount /dev/sr0 /mnt/dvd`, before dnf could read that path.)

---

CHECK IT WORKED

  First, just read the file back — the grader parses this exact stanza:

```run
cat /etc/yum.repos.d/local.repo
```

  Then let dnf itself confirm it recognises the new repo id. This lists all
  known repositories, enabled or not:

```run
dnf repolist --all 2>/dev/null | grep -i localdvd
```

  Seeing localdvd there means dnf successfully parsed your file. (dnf may
  print a warning that it can't reach file:///mnt/dvd — that's expected,
  since the path is empty; the definition is still valid and graded.)

---

GOTCHAS

  - The filename must end in .repo and live in /etc/yum.repos.d/ — dnf only
    reads *.repo files in that directory. A file called local.txt is
    invisible to it.
  - The id in [brackets] is what matters, not the filename. The grader
    wants the section [localdvd] specifically.
  - file:// takes three slashes total: file:// + /mnt/dvd/BaseOS. Two
    slashes is a common typo that breaks the URL.
  - Don't confuse name= (a label) with the id in brackets (the real
    identifier). Both are required but they play different roles.
