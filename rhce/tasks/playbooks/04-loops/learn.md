THE IDEA

  Often you want to do the same thing to a list of items — create three
  users, install five packages, open a handful of firewall ports. Instead of
  writing near-identical tasks over and over, you write ONE task and attach a
  loop: to it. Ansible runs that task once per item in the list.

  Inside the looped task you refer to the current item with the special
  variable {{ item }}. On the first pass item is the first list entry, on the
  second pass the second, and so on.

---

  Confirm the starting state — the users we're about to create should not
  exist yet:

```run
getent passwd app1 app2 app3 || echo "none of app1/app2/app3 exist yet"
```

---

WHY IT MATTERS

  Loops are the difference between a tidy playbook and a wall of copy-pasted
  tasks. The exam frequently gives you "create these users" or "manage these
  services" as a list — the expected answer is a single task with a loop, and
  graders (and colleagues) will mark down three duplicated tasks. It also
  keeps idempotence simple: one task, one place to reason about.

---

HOW TO DO IT

  We use the ansible.builtin.user module once, with name set to {{ item }},
  and feed it a loop of the three usernames. Write the playbook:

```run
cd /root/rhce/loops
cat > playbook.yml <<'EOF'
---
- name: Create application users with a loop
  hosts: managed
  become: true
  tasks:
    - name: Ensure the app users exist
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop:
        - app1
        - app2
        - app3
EOF
cat playbook.yml
```

  Look at the shape. loop: is a key of the TASK — same indentation as the
  module name (ansible.builtin.user), not nested inside it. Its value is a
  YAML list of three items. The module's name: "{{ item }}" is what changes
  each pass. become: true because creating users needs root.

---

  Run it:

```run
cd /root/rhce/loops
ansible-playbook playbook.yml
```

  In the output you'll see the task reported three times, once per item —
  each tagged with its item value. First run: changed=1 (three users
  created counts as a changed task).

---

  Run again for idempotence — the user module sees each account already
  exists and makes no change:

```run
cd /root/rhce/loops
ansible-playbook playbook.yml
```

  changed=0.

---

CHECK IT WORKED

  The grader checks that app1, app2 and app3 all exist and that the second
  run is idempotent. Verify the accounts directly:

```run
getent passwd app1 app2 app3
```

  Three lines, one per user.

---

GOTCHAS

  - loop: belongs to the task, aligned with the module key — a common
    mistake is over-indenting it under the module's arguments, which breaks
    it or is ignored.
  - Use {{ item }} exactly; that's the reserved name Ansible fills in each
    pass. Renaming it (without loop_control) won't work.
  - You'll see the old with_items: in legacy playbooks. It still works, but
    loop: is the current form — use loop: on the exam.
  - Don't write one task per user. It passes the grader by luck but misses
    the whole skill the task is testing.
