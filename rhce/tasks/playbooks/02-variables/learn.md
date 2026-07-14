THE IDEA

  A variable is a named value you define once and reuse by writing its name
  in {{ curly braces }}. Instead of scattering the same literal string across
  a playbook, you give it a name — target_file, message — and reference the
  name. Change the value in one place and every task that uses it follows.

  That {{ ... }} syntax is Jinja2 templating. When Ansible runs a task, it
  "renders" any {{ expression }} it finds, substituting the current value
  before the module ever sees it.

---

  Look at your working directory and the inventory, then we'll build the
  playbook:

```run
cd /root/rhce/variables
ls -la
cat inventory
```

  The [managed] group is localhost over a local connection, same as every
  task in this set.

---

WHY IT MATTERS

  On the exam you're often told "make the file contain THIS, using a
  variable" — the point is proving you can parameterise a playbook, not
  hard-code it. In real life variables are what let one playbook serve many
  hosts and environments: the logic stays fixed, the values vary. Knowing
  where to define them and how to reference them is fundamental.

---

HOW TO DO IT

  Variables can live in several places; the simplest is a vars: block right
  in the play. We define two, then use them — never the literals — inside
  the task. Write the playbook:

```run
cd /root/rhce/variables
cat > playbook.yml <<'EOF'
---
- name: Write a message to a file using variables
  hosts: managed
  vars:
    target_file: /root/rhce/vars/hello.txt
    message: "hello from ansible"
  tasks:
    - name: Ensure the file has the message
      ansible.builtin.copy:
        dest: "{{ target_file }}"
        content: "{{ message }}\n"
EOF
cat playbook.yml
```

  The vars: block sits at play level, alongside hosts:. Inside the task,
  dest: "{{ target_file }}" pulls the path from the variable, and content:
  "{{ message }}\n" pulls the text (the \n gives the file a trailing
  newline). The copy module with content: writes that string straight into
  the file — no separate template file needed — and it creates any missing
  parent directories in the destination path along the way.

  One rule worth burning in: when a value STARTS with {{, you must quote the
  whole thing, or YAML thinks you're starting a dictionary. That's why both
  values are in double quotes.

---

  Run it with ansible-playbook:

```run
cd /root/rhce/variables
ansible-playbook playbook.yml
```

  First run: changed=1, the file is created with the rendered content.

---

  Run it again to prove idempotence — the copy module compares the desired
  content against what's on disk and does nothing if they match:

```run
cd /root/rhce/variables
ansible-playbook playbook.yml
```

  changed=0 this time. That's what the grader wants.

---

CHECK IT WORKED

  The grader confirms the file exists and its content is exactly
  "hello from ansible", plus the idempotent second run. Check it yourself:

```run
cat /root/rhce/vars/hello.txt
```

  You should see the one line, rendered from the variable, not typed in
  literally.

---

GOTCHAS

  - Quote any value that begins with {{ — "{{ target_file }}" not
    {{ target_file }}. Unquoted, YAML misreads it and the play won't parse.
  - Use the variable, not the literal. A playbook that hard-codes
    /root/rhce/vars/hello.txt defeats the task even if the file ends up
    correct — the exam is testing that you referenced the variable.
  - {{ }} is for referencing a variable inside a string. You don't wrap the
    definition in the vars: block in braces — only the uses.
  - Watch the trailing newline: grep -x expects the whole line to match, so
    "hello from ansible\n" is right; extra spaces or a missing newline can
    trip content checks.
