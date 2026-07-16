THE IDEA

  ansible.cfg is Ansible's settings file. It tells Ansible things like
  which inventory to use, which user to log in as, and whether to
  escalate to root — so you don't have to pass those as command-line
  flags every single time. It's an INI file: sections in square
  brackets, then key = value lines under each.

  Ansible looks for ansible.cfg in several places and uses the FIRST it
  finds, in this order:

    1. $ANSIBLE_CONFIG (an environment variable)
    2. ./ansible.cfg   (the current working directory)  <-- we use this
    3. ~/.ansible.cfg  (your home directory)
    4. /etc/ansible/ansible.cfg

  A project-local ansible.cfg in the directory you run from wins over
  the system one, which is exactly why exam tasks live in their own
  working directory.

---

  Let's see the working directory. The setup left a placeholder
  `inventory` file here; our job is to add the ansible.cfg beside it.

```run
cd /opt/rhce/ansible-cfg && ls -la && cat inventory
```

---

WHY IT MATTERS

  On the exam you're often told exactly what ansible.cfg must contain —
  a specific inventory path, a remote user, privilege escalation turned
  on. Every later play then relies on those defaults. If become isn't
  configured here, tasks that need root will fail unless you remember to
  add `become: true` everywhere, so setting it once in ansible.cfg is
  both correct and less error-prone.

  Two sections matter for us:

    [defaults]              general settings (inventory, remote_user)
    [privilege_escalation]  how to become another user (usually root)

---

HOW TO DO IT

  We need:

    [defaults]
      inventory = inventory      which inventory file to read
      remote_user = ansible      the SSH login user

    [privilege_escalation]
      become = True              escalate privileges by default
      become_method = sudo       use sudo to do it
      become_user = root         become root specifically

  Write the whole file with a heredoc, keeping the two sections
  separate:

```run
cd /opt/rhce/ansible-cfg
cat > ansible.cfg <<'CFG'
[defaults]
inventory = inventory
remote_user = ansible

[privilege_escalation]
become = True
become_method = sudo
become_user = root
CFG
```

---

CHECK IT WORKED

  Don't just cat the file — ask Ansible what it actually parsed.
  `ansible-config dump --only-changed` shows every setting that differs
  from the built-in default, i.e. everything your file changed:

```run
cd /opt/rhce/ansible-cfg && ansible-config dump --only-changed
```

  You should see DEFAULT_HOST_LIST pointing at inventory,
  DEFAULT_REMOTE_USER = ansible, and the DEFAULT_BECOME* values. That's
  the primary thing the grader checks (with a plain-file parse as a
  fallback).

  You can also confirm which config file Ansible chose:

```run
cd /opt/rhce/ansible-cfg && ansible --version | grep 'config file'
```

  It should point at the ansible.cfg in this directory.

---

GOTCHAS

  - Section headers matter: become settings go under
    [privilege_escalation], NOT [defaults]. Putting become there is a
    common slip.
  - Run Ansible FROM this directory. ansible.cfg is only picked up from
    the current working directory (option 2 above) — cd elsewhere and
    Ansible reads a different config.
  - Ansible ignores a world-writable ansible.cfg in the current
    directory as a security measure. A normal file (default perms) is
    fine; just don't chmod 777 it.
  - `become = True` — the value is case-insensitive to Ansible, but
    keep it tidy and consistent.
