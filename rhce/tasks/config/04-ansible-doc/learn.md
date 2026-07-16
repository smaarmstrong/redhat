THE IDEA

  Nobody memorises every parameter of every Ansible module — there are
  thousands. Instead you look them up with ansible-doc, the built-in,
  offline documentation tool. Given a module name it prints that
  module's full reference: every parameter, what it does, defaults, and
  examples. It reads the same docs that power the website, straight from
  the installed collections, so it works with no internet.

---

  Here's the working directory. Empty for now — the deliverable is a
  small answer file we'll write at the end:

```run
cd /opt/rhce/ansible-doc && ls -la
```

---

WHY IT MATTERS

  This IS the exam skill. The RHCE is closed-book except for the docs
  that ship on the machine, and ansible-doc is your lifeline. When you
  can't remember whether the parameter is `shell`, `login_shell`, or
  something else, you look it up in seconds instead of guessing and
  failing. Being fast and fluent with ansible-doc during the real exam
  saves you again and again.

  Our specific question: in the ansible.builtin.user module, which
  parameter sets a user's login shell?

---

HOW TO DO IT

  First, a quick trick — the -s (snippet) flag prints a compact,
  playbook-ready list of a module's parameters with one-line comments.
  Great for scanning:

```run
ansible-doc -s ansible.builtin.user
```

  Scan that list for anything to do with the login shell. You'll spot a
  line for `shell` described as the user's shell.

---

  Now the full page. It's long, so pipe it through grep to pull out the
  lines mentioning the shell and read the description:

```run
ansible-doc ansible.builtin.user | grep -i shell
```

  The description confirms it: `shell` optionally sets the user's shell
  (on most platforms the login shell). In real practice you'd read the
  whole page with `ansible-doc ansible.builtin.user` (press q to quit
  the pager) — grep is just to keep this lesson tidy.

---

  The task wants ONLY the parameter name written to answer.txt — a
  single word, no quotes, no extra text:

```run
cd /opt/rhce/ansible-doc && echo shell > answer.txt && cat answer.txt
```

---

CHECK IT WORKED

  The grader reads answer.txt, strips whitespace, and checks it equals
  exactly `shell`. Confirm the file holds just that one word:

```run
cd /opt/rhce/ansible-doc && cat -A answer.txt
```

  You should see `shell$` — the word then an end-of-line marker, nothing
  else.

---

GOTCHAS

  - Write the parameter NAME only. Not "shell:", not "- shell", not a
    sentence — just the word shell. Extra characters fail the check.
  - Watch for a trailing space or a second line. `echo shell` adds one
    clean newline, which is fine; typing it by hand in an editor is
    where stray whitespace sneaks in.
  - Use the fully-qualified name ansible.builtin.user with ansible-doc.
    Plain `user` usually resolves too, but on the exam FQCNs are the
    safe habit.
  - Don't confuse `shell` (the login shell) with `create_home`,
    `home`, or `group` — read the descriptions, don't pattern-match the
    first parameter that looks close.
