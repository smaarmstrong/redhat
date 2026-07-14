THE IDEA

  A role is Ansible's unit of reuse. Instead of one giant playbook, you
  package a chunk of automation — its tasks, its files, its templates, its
  defaults, its handlers — into a standard directory tree with a fixed
  layout. Then any playbook applies it with a one-liner. Write once, use
  everywhere.

  The layout is a convention Ansible knows by heart. The minimum that
  matters for this task:

    roles/webconfig/
      tasks/main.yml    the tasks that run when the role is applied
      files/            static files that tasks can `copy` by name
      templates/        .j2 files (not needed here)
      defaults/         default variables
      handlers/         handlers

  The magic of the layout is path resolution: a task inside the role that
  says `copy: src: app.conf` automatically looks in that role's files/
  directory. You don't spell out full paths.

---

  Your working directory is /root/rhce/create-role. Its ansible.cfg
  already sets roles_path = roles, so Ansible finds roles under ./roles.
  The `managed` group is localhost. Nothing exists yet:

```run
ls /root/rhce/create-role/roles 2>/dev/null; echo "--- (empty) ---"
```

---

WHY IT MATTERS

  "Create and work with roles" is a whole RHCE domain. Roles are how real
  Ansible is organised, and the exam expects you to scaffold one, put
  working tasks in it, and drive it from a play. The habit to build: think
  in roles, not in ever-growing monolithic playbooks.

---

HOW TO DO IT

  You can scaffold the whole tree with `ansible-galaxy role init webconfig`
  (run from inside roles/) — that's the canonical way and worth knowing.
  Here we'll create just the parts we need by hand so the structure is
  obvious.

  Step 1 — make the role's tasks and files directories:

```run
cd /root/rhce/create-role
mkdir -p roles/webconfig/tasks roles/webconfig/files
```

  Step 2 — drop the config file into the role's files/ directory. Because
  it lives here, tasks can refer to it by bare name:

```run
cd /root/rhce/create-role
cat > roles/webconfig/files/app.conf <<'CONF'
# Managed by the webconfig role
[myapp]
enabled = true
log_level = info
CONF
```

---

  Step 3 — write tasks/main.yml, the entry point Ansible runs when the
  role is applied. It ensures the target directory exists, then copies
  app.conf into place (note src is just the bare filename):

```run
cd /root/rhce/create-role
cat > roles/webconfig/tasks/main.yml <<'TASKS'
---
- name: Ensure config directory exists
  ansible.builtin.file:
    path: /etc/myapp
    state: directory
    mode: '0755'

- name: Deploy app.conf
  ansible.builtin.copy:
    src: app.conf
    dest: /etc/myapp/app.conf
    mode: '0644'
TASKS
```

---

  Step 4 — write the playbook that USES the role. The `roles:` key is all
  it takes; Ansible finds webconfig under roles_path and runs its
  tasks/main.yml:

```run
cd /root/rhce/create-role
cat > site.yml <<'PB'
---
- name: Apply webconfig role
  hosts: managed
  become: true
  roles:
    - webconfig
PB
```

  Run it:

```run
cd /root/rhce/create-role
ansible-playbook site.yml
```

---

CHECK IT WORKED

  The role should have created the config file the grader checks for:

```run
cat /etc/myapp/app.conf
```

  Now confirm idempotency — apply the role again and look for changed=0.
  Both file and copy are idempotent, so nothing changes on a second pass:

```run
cd /root/rhce/create-role
ansible-playbook site.yml
```

---

GOTCHAS

  - The directory names are not optional. tasks/main.yml specifically is
    the entry point; a file called tasks/tasks.yml or a stray main.yaml
    won't be picked up.
  - src in a role's copy is relative to the role's files/. Don't write a
    full path — the whole point of the layout is that `src: app.conf`
    resolves to roles/webconfig/files/app.conf automatically.
  - roles_path lets Ansible find the role. It's set in ansible.cfg here;
    without it (and without the role being in the default location) the
    play errors with "role not found".
  - `roles:` at play level vs the `include_role` module mid-task are both
    valid; for "apply this role to these hosts", the roles: key is the
    clean, expected form.
