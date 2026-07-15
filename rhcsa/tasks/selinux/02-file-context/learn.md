THE IDEA

  Every file on an SELinux system carries a label — a security context —
  and the important part for us is its TYPE (the bit ending in _t, like
  httpd_sys_content_t). SELinux decides access by type: the web server is
  only allowed to read files typed httpd_sys_content_t. Put your web
  content anywhere with the wrong type and Apache gets "permission denied"
  even though the normal Unix permissions look fine.

  There are two separate ideas here, and mixing them up is the whole
  lesson:

    - The label physically on the file right now (what ls -Z shows).
    - The RULE in the policy that says "files matching this path should be
      typed X" (what semanage fcontext manages).

  restorecon is the bridge: it reads the rule and stamps the matching label
  onto the file.

---

  The file /web/index.html was created with a deliberately wrong type. Look
  at it:

```run
ls -Z /web/index.html
```

  You'll see something like ...:tmp_t:... — wrong. The web server would be
  refused. Our job: give it type httpd_sys_content_t, and make that the
  DEFAULT so it survives a relabel.

---

WHY IT MATTERS

  /web isn't a standard web root, so the policy has no rule for it — the
  default type there is generic. This is the everyday situation of serving
  content from a non-standard directory, and "the page 403s under SELinux"
  is one of the most common real-world tickets. The exam tests it because
  the naive fix (chcon) looks like it worked but silently breaks later.

---

THE CATCH: chcon IS NOT ENOUGH

  chcon changes the label on the file directly, right now. It works this
  second — but it writes nothing into the policy. The moment anyone runs a
  filesystem relabel (restorecon, or an autorelabel on boot), the policy
  has no rule for /web, so the label reverts and you're back to broken.

  The persistent way is two steps: add a policy RULE for the path, then
  apply it.

---

HOW TO DO IT

  Step 1 — add the file-context rule. semanage fcontext -a adds a mapping;
  -t sets the target type. We use a regex that covers the directory and
  everything under it, '/web(/.*)?', so index.html and any future files are
  all covered:

  Note: changing SELinux file-context policy — and even listing it
  with `semanage fcontext -l` — is privileged, so these commands are
  prefixed with `sudo`, a normal user who's been granted sudo,
  exactly the exam setup. (Reading a file's live label with `ls -Z`
  needs no sudo.)

```run
sudo semanage fcontext -a -t httpd_sys_content_t '/web(/.*)?'
```

  That only records the rule — it hasn't touched the file yet. Confirm the
  rule exists:

```run
sudo semanage fcontext -l | grep '/web'
```

---

  Step 2 — apply the rule to the files on disk with restorecon. -R makes it
  recursive, -v makes it tell you what it changed:

```run
sudo restorecon -Rv /web
```

  You should see it relabel /web/index.html from the old type to
  httpd_sys_content_t. Because the label now comes FROM the policy, a future
  restorecon or reboot will just re-apply the same correct type.

---

CHECK IT WORKED

  The current label on the file:

```run
ls -Z /web/index.html
```

  It should read ...:httpd_sys_content_t:... now. And the persistent rule
  that guarantees it stays that way:

```run
sudo semanage fcontext -l | grep '/web'
```

  The grader checks both: the live label via ls -Z, AND that a semanage
  rule maps the path to httpd_sys_content_t. That second check is why chcon
  alone fails this task.

---

GOTCHAS

  - chcon is a trap. It survives until the next relabel, then vanishes. For
    anything that must persist, always semanage fcontext + restorecon.
  - Adding the rule does NOT change existing files — you must run
    restorecon afterwards to stamp it on.
  - Quote the path regex ('/web(/.*)?') so the shell doesn't expand the
    special characters.
  - If a rule for the path already exists and you want to change it, use
    -m (modify) instead of -a (add), or delete with -d first.
