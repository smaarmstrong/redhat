THE IDEA

  The umask is a mask that decides the permissions new files and
  directories get. It works by SUBTRACTION: the system starts from a base
  (666 for files, 777 for directories) and removes the bits set in the
  umask. So:

    umask 022  ->  files 644, dirs 755   (the common default; group/other
                                          can read)
    umask 077  ->  files 600, dirs 700   (owner only; group/other get
                                          nothing)

  A 077 umask is the tightening you apply when new files should be private
  to their owner by default.

---

  See what a login shell uses today. The setup removed any custom drop-in,
  so you're looking at the system default:

```run
bash -lc umask
```

  It prints 0022 (or similar). New files land world-readable. We want a
  fresh login shell to report 0077 instead — permanently.

---

WHY IT MATTERS

  Default permissions are a quiet security control: get them wrong and every
  file a user creates is readable by everyone on the box. "Make new files
  private by default" is a standard hardening request, and the exam checks
  it the honest way — by starting a brand-new login shell and reading the
  umask, so a change that only affects your current shell won't count.

---

WHERE THE SETTING GOES

  You could type `umask 077` in your shell, but that dies with the shell.
  For it to apply to every login, it belongs in the login-shell startup
  path. On RHEL that path (/etc/profile) sources every *.sh file in
  /etc/profile.d/ — which is the clean, drop-in place for site settings.
  You do NOT hand-edit /etc/profile itself; you drop a small file into
  /etc/profile.d/.

---

HOW TO DO IT

  Create the drop-in with a single umask line:

```run
echo 'umask 077' | sudo tee /etc/profile.d/umask.sh
```

  Give it sane, world-readable permissions so every login shell can source
  it:

```run
sudo chmod 0644 /etc/profile.d/umask.sh
```

  That's it — no reboot needed for it to take effect on the NEXT login,
  because /etc/profile.d is read every time a login shell starts.

---

CHECK IT WORKED

  The whole point is that a FRESH login shell picks it up. bash -l starts
  one, and running umask inside it shows the result:

```run
bash -lc umask
```

  It should now print 0077. That is exactly the grader's main check. You can
  also confirm the file is in place:

```run
cat /etc/profile.d/umask.sh
```

  The grader verifies three things: the file exists and is readable, it
  contains a umask 077 line, and a fresh login shell actually reports 0077.

---

GOTCHAS

  - A umask typed at the prompt, or added only to your own ~/.bashrc, won't
    satisfy a system-wide, fresh-login check. Use /etc/profile.d/.
  - The file must be readable (0644). If it's not readable by the shell
    sourcing it, the setting silently doesn't apply.
  - 077 vs 0077 are the same value; the grader accepts either spelling.
  - Remember umask is subtractive: 077 gives 600/700, not 077 permissions.
