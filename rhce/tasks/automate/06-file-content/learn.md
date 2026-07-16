THE IDEA

  Two modules let you edit a file surgically instead of overwriting it:

    ansible.builtin.lineinfile    ensures ONE specific line is present (or absent)
    ansible.builtin.blockinfile   manages a MULTI-line block between markers

  lineinfile is for a single setting — "this exact line must be in the file".
  blockinfile wraps several lines between # BEGIN ANSIBLE MANAGED BLOCK and
  # END ANSIBLE MANAGED BLOCK comments, so Ansible can find and update its own
  block later without disturbing the rest of the file. Both are idempotent:
  the line/block is added only if it isn't already there in the right form.

  This task manages /etc/security/limits.d/99-custom.conf. setup.sh deleted
  that file, so your playbook must be able to create it. Working directory:
  /opt/rhce/file-content/.

---

  Confirm the file is gone at the start:

```run
ls -l /etc/security/limits.d/99-custom.conf 2>&1
```

  "No such file or directory" — so the playbook needs create: true on the
  first module to bring the file into existence.

---

WHY IT MATTERS

  Real config files (sshd_config, sysctl, limits, hosts) mostly need a line
  changed, not the whole file replaced. lineinfile and blockinfile are the
  RHCE's tools for that: they make targeted edits idempotently, so re-running
  never duplicates a line or clobbers a neighbour. The grader checks for the
  exact line and for the managed-block markers.

---

HOW TO DO IT

  Write the playbook. First task uses lineinfile with create: true (so a
  missing file is created) and sets a mode; second task uses blockinfile with
  a two-line block:

```run
cd /opt/rhce/file-content
cat > playbook.yml <<'EOF'
---
- name: Manage limits file content
  hosts: managed
  become: true
  tasks:
    - name: Ensure the nofile soft limit line is present
      ansible.builtin.lineinfile:
        path: /etc/security/limits.d/99-custom.conf
        line: "* soft nofile 4096"
        state: present
        create: true
        mode: '0644'

    - name: Ensure a managed block of custom limits
      ansible.builtin.blockinfile:
        path: /etc/security/limits.d/99-custom.conf
        block: |
          * hard nofile 8192
          * soft nproc 2048
EOF
```

  lineinfile guarantees that one line exists exactly once. blockinfile takes a
  multi-line `block:` (the | is a YAML literal block scalar, keeping the lines
  as written) and surrounds it with the BEGIN/END markers automatically — you
  don't type the markers yourself.

---

  Run it:

```run
cd /opt/rhce/file-content && ansible-playbook playbook.yml
```

  changed=2 — one line added, one block added. Re-run for idempotence:

```run
cd /opt/rhce/file-content && ansible-playbook playbook.yml
```

  changed=0: the line is already present and the block already matches between
  its markers, so neither module touches the file.

---

CHECK IT WORKED

  The grader checks the file exists, contains the exact nofile line, and has
  both managed-block markers. Look at the result:

```run
cat /etc/security/limits.d/99-custom.conf
```

  You should see `* soft nofile 4096`, then the # BEGIN ANSIBLE MANAGED BLOCK
  / # END ANSIBLE MANAGED BLOCK pair wrapping your two block lines.

---

GOTCHAS

  - create: true on lineinfile matters here — the file doesn't exist at the
    start, and without it the module fails on a missing path.
  - Let blockinfile write its own markers; don't type BEGIN/END yourself. The
    markers are how it finds and updates the block idempotently.
  - The grader wants the nofile line EXACTLY (grep -Fxq): "* soft nofile 4096"
    with single spaces. Match it character for character.
  - Keep the two edits in separate modules — lineinfile for the single line,
    blockinfile for the block. That's what the objective is exercising.
