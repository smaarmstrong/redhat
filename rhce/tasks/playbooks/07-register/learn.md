THE IDEA

  Most modules do something; sometimes you also want to CAPTURE what they
  returned — a command's output, whether it changed, its exit status — and use
  it later. register: saves a task's entire result into a variable of your
  choosing. Later tasks read fields off that variable.

  For a command, the field you almost always want is .stdout — the text the
  command printed. So a task with register: whoami_result makes
  {{ whoami_result.stdout }} available downstream.

---

  Confirm the output file doesn't exist yet:

```run
ls -l /opt/rhce/register/whoami.txt 2>&1 || true
```

---

WHY IT MATTERS

  Playbooks constantly need to act on the result of a previous step: grab a
  version string, capture a generated key, branch on whether a check passed.
  register is the mechanism for all of it, and it pairs with when: (act on
  the result) and debug: (print it). The exam objective is literally "use
  variables to retrieve the results of running a command" — that's register,
  by name.

---

HOW TO DO IT

  We run id -un with the command module, register the result, then feed its
  .stdout into a copy task that writes the file. Because the play becomes
  root, id -un prints "root". Write the playbook:

```run
cd /opt/rhce/register
cat > playbook.yml <<'EOF'
---
- name: Capture a command result with register
  hosts: managed
  become: true
  tasks:
    - name: Find out who we run as
      ansible.builtin.command: id -un
      register: whoami_result
      changed_when: false

    - name: Save the result to a file
      ansible.builtin.copy:
        dest: /opt/rhce/register/whoami.txt
        content: "{{ whoami_result.stdout }}\n"
EOF
cat playbook.yml
```

  register: whoami_result and changed_when: false are keys of the first
  TASK, aligned with the module. That changed_when: false is worth
  understanding: the command module reports "changed" every single time by
  default (Ansible can't know if running a command altered anything). Since
  id -un only READS, we tell Ansible it never counts as a change — which keeps
  the run honest. The second task pulls {{ whoami_result.stdout }} out of the
  registered variable and writes it.

---

  Run it:

```run
cd /opt/rhce/register
ansible-playbook playbook.yml
```

  The first task gathers the result, the second writes it. Thanks to
  changed_when: false, only the copy contributes a change on the first run.

---

  Want to SEE what got registered? Add a quick debug on the command line —
  this doesn't touch your playbook, it just prints the variable's structure:

```run
cd /opt/rhce/register
ansible managed -b -m command -a 'id -un'
```

  That shows the raw module return — stdout, rc, and so on — the same shape
  register captures into whoami_result.

---

CHECK IT WORKED

  The grader checks the playbook uses register:, the run succeeds, the file
  exists, and it contains exactly "root". Look at the file:

```run
cat /opt/rhce/register/whoami.txt
```

  One line: root. That's the captured stdout, written out.

---

GOTCHAS

  - It's .stdout for the text. .stdout_lines gives a list split by line;
    .rc is the exit code. Reaching for the wrong field is a common slip.
  - register: is a task key, aligned with the module name — not an argument
    passed into the module.
  - The command module always reports changed unless you set
    changed_when: false. Not strictly required to pass here, but it's the
    correct, idempotent habit for read-only commands.
  - Don't confuse command with shell. command is fine here (no pipes or
    redirection); use shell only when you genuinely need shell features.
