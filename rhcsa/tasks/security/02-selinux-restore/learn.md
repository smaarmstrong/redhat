THE IDEA

  Every file under SELinux carries a security context, and its TYPE (the
  _t part) is what SELinux uses to allow or deny access. The system policy
  already knows the correct default type for standard locations — files
  under /var/www, the normal web root, default to httpd_sys_content_t.

  When a single file ends up with the wrong label — a careless copy, a mv
  from somewhere else, a stray chcon — the fix is not to invent a new rule.
  The policy already says what the label SHOULD be. You just need to reset
  the file back to that default. The tool for that is restorecon.

---

  The file /var/www/page.html was deliberately mislabelled by the setup.
  Look at its current context:

```run
ls -Z /var/www/page.html
```

  You'll see a wrong type in there (something like user_home_t or tmp_t).
  The directory /var/www itself is correctly labelled — only this one file
  is off.

---

WHY IT MATTERS

  A mislabelled file is one of the most common SELinux gotchas in real
  life: you cp a page into the web root, the web server can't read it, and
  the logs say permission denied even though ls -l looks perfect. Knowing
  that restorecon puts the label back to the policy default — rather than
  disabling SELinux or hand-crafting a rule — is the mark of someone who
  actually understands the model. The exam tests exactly this.

---

HOW TO DO IT

  Because the correct default already lives in the policy, this is a
  one-liner. restorecon looks up the policy rule for the path and stamps the
  right label onto the file. -v makes it report what it changed.
  Relabelling a file is privileged, so restorecon is prefixed with
  `sudo` — a normal user who's been granted sudo, exactly the exam
  setup. (Reading the label with `ls -Z` needs no sudo.)

```run
sudo restorecon -v /var/www/page.html
```

  You should see it announce the relabel, from the wrong type to
  httpd_sys_content_t. No semanage rule is needed here — that's for paths
  the policy DOESN'T already know about; /var/www it knows.

---

CHECK IT WORKED

  Re-inspect the context:

```run
ls -Z /var/www/page.html
```

  The type should now read httpd_sys_content_t. That's precisely what the
  grader looks for with ls -Z.

---

GOTCHAS

  - Don't reach for chcon here. chcon -t httpd_sys_content_t would also fix
    the visible label, but restorecon is the right tool when the policy
    already defines the default — it's what a relabel would apply, so it's
    self-consistent and can't drift. This task is literally "restore the
    default", so restorecon is the intended answer.
  - Don't add a semanage fcontext rule — the path already maps to the
    correct type. Adding a rule for /var/www would be redundant and could
    even conflict with the shipped policy.
  - restorecon relabels a single file as shown; add -R to recurse a whole
    directory tree when many files are wrong.
  - If SELinux were Disabled there'd be no label to restore — this only
    matters while SELinux is enforcing or permissive.
