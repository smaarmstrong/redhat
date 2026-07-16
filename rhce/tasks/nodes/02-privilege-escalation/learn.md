THE IDEA

  Ansible logs into a managed node as an ordinary user — here, `ansible`.
  But most real work (installing packages, editing /etc, restarting
  services) needs root. The bridge is privilege escalation: Ansible logs
  in as the unprivileged user, then becomes root with sudo. In playbooks
  that's the one word `become: true`.

  For become to work non-interactively, the login user must be able to run
  sudo WITHOUT being asked for a password — otherwise every play would
  hang waiting for input. So the setup half of this is a system config
  job: grant the ansible user passwordless sudo.

  You do that with a "drop-in" file under /etc/sudoers.d/ containing:

    ansible ALL=(ALL) NOPASSWD: ALL

  meaning: user ansible, on ALL hosts, may run as ALL users, ALL commands,
  with NOPASSWD (no password prompt).

---

  Your working directory is /opt/rhce/privilege-escalation, with an
  inventory whose `managed` group is just localhost. Confirm there's no
  sudoers drop-in for ansible yet:

```run
sudo ls -l /etc/sudoers.d/ansible 2>/dev/null || echo "no drop-in yet"
```

---

WHY IT MATTERS

  Two reasons this is its own objective. First, it's what makes `become`
  usable across your whole fleet — without it, automation stalls. Second,
  sudoers is unforgiving: a single typo in a sudoers file can lock every-
  one out of root on that box. That's why you NEVER edit these files with
  a plain text editor and hope. You validate them, always.

---

HOW TO DO IT

  We deploy the drop-in with the copy module — and crucially with its
  `validate` option. validate runs a command against the proposed file in
  a temp location BEFORE moving it into place; if the check fails, the file
  is never installed. For sudoers the check is `visudo -cf %s` (the `%s`
  is where Ansible substitutes the temp path). A bad file is rejected, and
  your system stays safe.

  Write the playbook:

```run
cd /opt/rhce/privilege-escalation
cat > playbook.yml <<'PB'
---
- name: Configure passwordless sudo for the ansible user
  hosts: managed
  become: true
  tasks:
    - name: Deploy a validated sudoers drop-in for ansible
      ansible.builtin.copy:
        dest: /etc/sudoers.d/ansible
        content: "ansible ALL=(ALL) NOPASSWD: ALL\n"
        owner: root
        group: root
        mode: '0440'
        validate: 'visudo -cf %s'
PB
```

  Note the mode 0440 — sudoers files must not be writable, and sudo warns
  about wrong modes. Now run it:

```run
cd /opt/rhce/privilege-escalation
ansible-playbook playbook.yml
```

---

CHECK IT WORKED

  Look at the file that landed:

```run
sudo cat /etc/sudoers.d/ansible
sudo ls -l /etc/sudoers.d/ansible
```

  Confirm the whole sudoers configuration still parses cleanly — this is
  what the grader runs, and what saves you from a lockout:

```run
sudo visudo -cf /etc/sudoers && echo "sudoers OK"
```

  The grader also insists the playbook is idempotent. Run it a second time
  and look for changed=0 — copy sees the file already matches and does
  nothing:

```run
cd /opt/rhce/privilege-escalation
ansible-playbook playbook.yml
```

---

GOTCHAS

  - Always use validate on sudoers. Deploying a broken sudoers file with-
    out it can wedge root access on the node. This is the single most
    important habit in this task.
  - mode: '0440', owner/group root. sudo ignores drop-ins with sloppy
    permissions.
  - Prefer /etc/sudoers.d/ over editing /etc/sudoers directly — drop-ins
    are self-contained, easy to template, and easy to remove.
  - Idempotency comes for free here because copy compares content. If you
    ever build the file with lineinfile or a shell command instead, watch
    that a second run still reports changed=0.
