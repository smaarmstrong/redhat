THE IDEA

  Ansible does its work by running a "playbook": a YAML file that lists, in
  order, the desired state you want on a set of machines. You don't write the
  steps to GET there ("run dnf install...") — you declare the end state
  ("this package is present") and let Ansible figure out whether anything
  needs doing. That declarative style is the whole point, and it's why a
  well-written playbook can run twice with no harm.

  A playbook is a list of "plays". A play names which hosts to target and
  carries a list of "tasks". Each task calls a "module" — a small unit of
  work like ansible.builtin.package — with some arguments.

---

  You already have a working directory set up for this task. Look at what's
  there:

```run
cd /root/rhce/install-package
ls -la
cat inventory
cat ansible.cfg
```

  The inventory file lists the machines Ansible manages, grouped under
  [managed]. Here that group is just localhost, reached with a local
  connection (no SSH). The ansible.cfg tells ansible-playbook to read that
  inventory automatically, so you never have to pass -i on the command line.

---

WHY IT MATTERS

  "Ensure package X is installed on these hosts" is the most basic building
  block of configuration management, and it turns up on the exam constantly —
  usually as one task inside a larger playbook. Get the play header and a
  single package task right and you've got the skeleton every other playbook
  hangs off.

---

HOW TO DO IT

  We'll write playbook.yml with a heredoc so you can see the exact YAML.
  Watch the structure: a top-level list item (the play) with name/hosts/
  become, then a tasks: list, then one task calling the package module.

```run
cd /root/rhce/install-package
cat > playbook.yml <<'EOF'
---
- name: Install tree
  hosts: managed
  become: true
  tasks:
    - name: Ensure tree is installed
      ansible.builtin.package:
        name: tree
        state: present
EOF
cat playbook.yml
```

  A few things to notice. The leading --- marks the start of a YAML
  document. hosts: managed matches the inventory group. become: true means
  "do this as root" (installing packages needs privilege). The
  ansible.builtin.package module is the distro-agnostic package manager —
  it maps to dnf on Rocky. state: present means "make sure it's there";
  Ansible only acts if it's missing.

---

  Now run it exactly the way the task asks — with ansible-playbook:

```run
cd /root/rhce/install-package
ansible-playbook playbook.yml
```

  Read the PLAY RECAP at the bottom. The first time you'll see
  changed=1 — Ansible installed tree. It reports "changed" because it
  actually altered the system.

---

  Idempotence is the property that running the same playbook again makes no
  further changes. It's not optional here — the grader checks for it. Run it
  a second time:

```run
cd /root/rhce/install-package
ansible-playbook playbook.yml
```

  This time the recap shows changed=0: tree is already installed, so the
  package module does nothing. That "ok" with no change is exactly what a
  declarative tool should do.

---

CHECK IT WORKED

  The grader confirms the file exists, the syntax is valid, the run
  succeeds, the package is actually installed, and the second run reports
  changed=0. You can spot-check the package yourself:

```run
rpm -q tree
```

  And you can validate the YAML without running anything — handy on the exam
  before you commit to a full run:

```run
cd /root/rhce/install-package
ansible-playbook --syntax-check playbook.yml
```

---

GOTCHAS

  - YAML is indentation-sensitive and hates tabs. Use spaces, keep the two-
    space steps consistent, and line up list items under their key.
  - Don't reach for the command or shell module to run "dnf install".
    That's not idempotent (it "changes" every run) and it throws away the
    whole point of a module. Use ansible.builtin.package.
  - state: present, not latest, unless the task specifically asks to
    upgrade — latest can report changed on a later run when a new version
    appears, breaking idempotence.
  - Forgetting become: true is the classic silent failure: the play runs
    but can't install as an unprivileged user.
