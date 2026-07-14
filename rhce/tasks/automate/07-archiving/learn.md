THE IDEA

  Bundling files into a compressed archive — the tar czf of everyday admin —
  has an Ansible module:

    community.general.archive

  You point it at a `path:` (a file or directory to pack), a `dest:` (where
  the archive goes), and a `format:` (gz, bz2, zip, xz...). It packs and
  compresses in one step. This task archives /etc/ssh into
  /root/rhce/archiving/etc-backup.tar.gz as gzip.

  Note archive lives in the community.general collection, not ansible-core;
  setup.sh best-effort installs it. Working directory: /root/rhce/archiving/.

---

  Confirm there's no archive yet:

```run
ls -l /root/rhce/archiving/etc-backup.tar.gz 2>&1
```

  "No such file or directory" — the playbook will create it.

---

WHY IT MATTERS

  Backing up config before a change, or collecting logs to ship elsewhere, is
  routine work, and the archive module makes it a one-task, repeatable step
  instead of a shell pipeline. The exam objective is "archive files"; the
  grader checks that a valid .tar.gz appears and that it actually contains the
  SSH config.

---

HOW TO DO IT

  Write the playbook. become: true so it can read all of /etc/ssh (some files
  there are root-only):

```run
cd /root/rhce/archiving
cat > playbook.yml <<'EOF'
---
- name: Archive the SSH configuration
  hosts: managed
  become: true
  tasks:
    - name: Create a gzip archive of /etc/ssh
      community.general.archive:
        path: /etc/ssh
        dest: /root/rhce/archiving/etc-backup.tar.gz
        format: gz
EOF
```

  path: /etc/ssh is what gets packed; dest is the output file; format: gz
  makes it gzip (a .tar.gz / tarball). The module creates the tar and gzips it
  for you.

---

  Run it:

```run
cd /root/rhce/archiving && ansible-playbook playbook.yml
```

  changed=1 and the archive file now exists. Re-run to see idempotence:

```run
cd /root/rhce/archiving && ansible-playbook playbook.yml
```

  On an unchanged source tree the module reports changed=0 — it sees the
  archive already reflects the current contents. (If the platform's tar embeds
  timestamps that defeat this, the file still exists and is valid, which is
  what ultimately matters.)

---

CHECK IT WORKED

  The grader confirms the file exists, is a valid gzip tarball, and contains
  sshd_config. List the archive's contents:

```run
tar -tzf /root/rhce/archiving/etc-backup.tar.gz | head
```

  You should see the /etc/ssh members, including sshd_config, and tar should
  read the file without error (that's the "valid gzip tarball" check).

---

GOTCHAS

  - format: gz gives you .tar.gz. Match the format to the .tar.gz extension the
    task asks for; format: zip would produce something the grader's tar can't
    read.
  - Use the fully-qualified name community.general.archive. If the collection
    is missing, `ansible-galaxy collection install community.general` installs
    it (setup.sh already tried).
  - become: true — /etc/ssh contains root-only host keys; without root the
    archive step can fail or silently skip files.
  - path is the source, dest is the output. Swapping them is a common slip.
