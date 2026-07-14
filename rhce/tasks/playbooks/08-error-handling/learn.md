THE IDEA

  By default, the moment a task fails, Ansible stops the play for that host —
  everything after it is abandoned. Sometimes that's too blunt: you want to
  TRY something, and if it fails, take corrective action and carry on. That's
  what block:/rescue: gives you, and it reads just like try/except in a
  programming language.

    block:    a list of tasks to attempt
    rescue:   tasks that run ONLY if a task in the block failed
    always:   (optional) tasks that run either way

  If the block succeeds, rescue is skipped. If the block fails, Ansible jumps
  into rescue — and crucially, if rescue itself completes cleanly, the play is
  considered SUCCESSFUL and exits 0. The failure was handled.

---

  Confirm the recovery marker doesn't exist yet:

```run
ls -l /root/rhce/error-handling/recovered.txt 2>&1 || true
```

---

WHY IT MATTERS

  Robust automation has to cope with the expected-failure case: a service
  that might not be running, a file that might not exist, a command that could
  return non-zero. block:/rescue: lets a playbook recover gracefully instead
  of dying halfway and leaving the host in a half-configured mess. The exam
  objective is "configure error handling", and this is the tool it means.

---

HOW TO DO IT

  We put a task that fails on purpose (running /bin/false, which always exits
  1) inside a block:. In rescue:, we create the recovered.txt marker. Because
  rescue handles the failure, the overall run succeeds. Write the playbook:

```run
cd /root/rhce/error-handling
cat > playbook.yml <<'EOF'
---
- name: Handle a task failure with block/rescue
  hosts: managed
  become: true
  tasks:
    - name: Try something that fails, then recover
      block:
        - name: This task fails on purpose
          ansible.builtin.command: /bin/false
      rescue:
        - name: Record that we recovered
          ansible.builtin.file:
            path: /root/rhce/error-handling/recovered.txt
            state: touch
EOF
cat playbook.yml
```

  Notice the structure: block: and rescue: are keys of a single TASK entry
  (the one named "Try something..."), and each holds its OWN list of tasks,
  indented one level further. /bin/false exits non-zero, so the command
  module marks that task failed — which triggers the rescue, where the file
  module touches the marker.

---

  Run it:

```run
cd /root/rhce/error-handling
ansible-playbook playbook.yml
```

  Read the output carefully. You'll see the "fails on purpose" task reported
  as fatal/failed — but then the play does NOT stop. It runs the rescue task,
  and the final recap shows failed=0. The failure was caught. That's the
  whole trick: a failed task inside a rescued block does not fail the play.

---

  Prove the exit status is really 0 (success), which is what matters:

```run
cd /root/rhce/error-handling
ansible-playbook playbook.yml; echo "exit status: $?"
```

  exit status: 0 — the play succeeded because rescue handled things.

---

CHECK IT WORKED

  The grader checks the playbook uses block: and rescue:, the run exits 0,
  and recovered.txt exists (proving rescue ran). Confirm the marker:

```run
ls -l /root/rhce/error-handling/recovered.txt
```

---

GOTCHAS

  - Seeing a red "fatal" line in the output is EXPECTED here — the block task
    is meant to fail. What counts is failed=0 in the recap and exit 0,
    because rescue caught it. Don't panic at the red text.
  - block:, rescue: (and always:) are all keys of ONE task, each holding a
    sub-list of tasks. Getting the indentation of those sub-lists right is the
    fiddly part — they sit one level deeper than the block:/rescue: keys.
  - rescue only fires if a block task actually fails. If nothing in the block
    fails, rescue is skipped and the marker would never be created.
  - If a task in rescue itself fails, the play fails for real — rescue is your
    one safety net, so keep its tasks simple and reliable.
