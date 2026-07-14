THE IDEA

  Ansible ships a small core of modules (the ansible.builtin.* ones).
  Everything else lives in "collections" — bundles of modules, roles,
  and plugins distributed through Ansible Galaxy. community.general, for
  instance, packs hundreds of extra modules that aren't in core.

  To use a module from a collection you do two things: install the
  collection, then call its modules by their fully-qualified collection
  name (FQCN), like community.general.ini_file. The FQCN is
  namespace.collection.module — three dotted parts — and it's how
  Ansible knows exactly which module you mean.

  Note: this is a BONUS task — installing from Galaxy needs internet. If
  the box is offline the steps still teach the skill; the grader just
  notes the lack of network.

---

  The setup gave us a project with an ansible.cfg that sets
  collections_path = collections, so collections install into a local
  folder rather than system-wide:

```run
cd /root/rhce/collection-use && ls -la && cat ansible.cfg && cat inventory
```

---

WHY IT MATTERS

  On the exam you may be told to use a module that isn't in core — you
  have to know how to fetch its collection and reference it correctly.
  The professional pattern is a requirements.yml file listing what you
  need, so the install is repeatable and documented, rather than
  installing collections ad hoc. That file-plus-install workflow is the
  graded skill.

---

HOW TO DO IT

  Step 1 — declare the dependency. Create
  collections/requirements.yml listing community.general under a
  top-level collections: key:

```run
cd /root/rhce/collection-use
mkdir -p collections
cat > collections/requirements.yml <<'REQ'
---
collections:
  - name: community.general
REQ
```

---

  Step 2 — install it from the requirements file into the project's
  local collections directory (-p collections):

```run
cd /root/rhce/collection-use && ansible-galaxy collection install -r collections/requirements.yml -p collections
```

  If you have no network to Galaxy this is the step that fails — that's
  expected for the bonus. Confirm what's now installed:

```run
cd /root/rhce/collection-use && ansible-galaxy collection list
```

  Look for community.general in the list.

---

  Step 3 — use a module from it. Write a playbook that targets the
  managed group and calls community.general.ini_file by its FQCN to
  create /etc/myapp.ini with [main] enabled=true:

```run
cd /root/rhce/collection-use
cat > playbook.yml <<'PB'
---
- name: Use a module from community.general
  hosts: managed
  become: true
  tasks:
    - name: Write an INI setting
      community.general.ini_file:
        path: /etc/myapp.ini
        section: main
        option: enabled
        value: "true"
        mode: '0644'
PB
```

  Now run it:

```run
cd /root/rhce/collection-use && ansible-playbook playbook.yml
```

---

CHECK IT WORKED

  The grader checks the requirements file names community.general, the
  collection is installed, the playbook's syntax is valid, it runs
  clean, and /etc/myapp.ini exists. Verify the file and its contents:

```run
cat /etc/myapp.ini
```

  You should see a [main] section with enabled = true. A quick
  syntax-only check (no changes made) is also worth knowing:

```run
cd /root/rhce/collection-use && ansible-playbook --syntax-check playbook.yml
```

---

GOTCHAS

  - Call the module by its full FQCN: community.general.ini_file. Just
    `ini_file` won't resolve — that name only exists inside the
    collection.
  - -p collections installs LOCALLY into this project (matching
    collections_path in ansible.cfg). Without it, the collection lands
    in ~/.ansible and the local path won't find it.
  - value: "true" is quoted so YAML treats it as the string "true", not
    the boolean — ini_file writes a literal string into the file.
  - This step needs internet to Galaxy. Offline, install and run will
    fail; that's the "bonus" caveat, not a mistake on your part.
  - become: true is needed because /etc/myapp.ini lives in /etc — a
    normal user can't write there.
