THE IDEA

  Two modules cover user and group management, and they mirror the useradd /
  groupadd commands you know from RHCSA:

    ansible.builtin.group   create/remove a group, optionally with a fixed GID
    ansible.builtin.user    create/remove a user, set groups, comment, shell...

  Order matters: create the group first so the user can be put into it. This
  task creates the group `devs` with GID 6000, then the user `deploybot` with
  devs as a SUPPLEMENTARY group and a GECOS comment.

  setup.sh removed both the user and group so there's work to do. Working
  directory: /opt/rhce/users-groups/.

---

  Confirm they don't exist yet:

```run
getent group devs; getent passwd deploybot; echo "exit: $?"
```

  Both lookups come back empty. Your playbook will bring them into being.

---

WHY IT MATTERS

  Provisioning users and groups is bread-and-butter sysadmin, and the exam
  wants it repeatable across a fleet. The subtle bit is "supplementary" vs
  "primary" group and the append behaviour — get that wrong and you either
  clobber a user's other group memberships or set the wrong primary group. The
  grader specifically checks that deploybot is a MEMBER of devs and has a
  comment.

---

HOW TO DO IT

  Write the playbook — group task first, then user task:

```run
cd /opt/rhce/users-groups
cat > playbook.yml <<'EOF'
---
- name: Create devs group and deploybot user
  hosts: managed
  become: true
  tasks:
    - name: Ensure devs group exists with GID 6000
      ansible.builtin.group:
        name: devs
        gid: 6000
        state: present

    - name: Ensure deploybot user exists in devs
      ansible.builtin.user:
        name: deploybot
        groups: devs
        append: true
        comment: Deployment robot
        state: present
EOF
```

  The two attributes to understand on the user module: `groups:` lists
  SUPPLEMENTARY groups (the primary group is set by `group:`, singular, which
  we leave to the default). `append: true` means "add these groups without
  removing the ones the user already has" — leave it off and Ansible would set
  groups to EXACTLY this list, dropping any others. `comment:` fills the GECOS
  field.

---

  Run it:

```run
cd /opt/rhce/users-groups && ansible-playbook playbook.yml
```

  changed=2. Then re-run to confirm idempotence:

```run
cd /opt/rhce/users-groups && ansible-playbook playbook.yml
```

  changed=0 — the group and user already match, so nothing happens.

---

CHECK IT WORKED

  The grader checks the group's GID, that the user exists and is a member of
  devs, and that the comment is non-empty. Inspect them yourself:

```run
getent group devs
id -nG deploybot
getent passwd deploybot
```

  You want devs showing GID 6000, `devs` appearing in deploybot's group list,
  and "Deployment robot" in the 5th (GECOS) field of the passwd line.

---

GOTCHAS

  - groups: (plural) = supplementary; group: (singular) = primary. This task
    wants devs as supplementary, so use groups: devs.
  - append: true matters when a user already has memberships. Without it, the
    user module treats groups: as the complete set and removes others. It's a
    safe habit even on a fresh user.
  - Create the group before the user. If the group doesn't exist yet, the user
    task fails to place the user in it.
  - state: present is the default for both, but writing it makes intent clear.
