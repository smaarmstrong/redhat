THE IDEA

  Sometimes a task should only run when some condition holds — this package
  only on Red Hat family systems, that config only when a service is present.
  You attach a when: clause to the task. Ansible evaluates the expression per
  host; if it's true the task runs, if false the task is skipped.

  The expression is plain Jinja2/Python-style, and here's the one twist that
  trips people: inside when: you write bare variable names WITHOUT the
  {{ curly braces }}. So it's when: ansible_distribution == "Rocky", not
  when: {{ ansible_distribution }} == "Rocky".

---

  This box is Rocky, which we can confirm from its facts before we start:

```run
cd /root/rhce/conditionals
ansible managed -m ansible.builtin.setup -a 'filter=ansible_distribution'
```

  You'll see ansible_distribution reported as "Rocky". That's the fact our
  condition will test.

---

WHY IT MATTERS

  Real playbooks run against mixed fleets, and a task that's right for one OS
  is wrong (or fails) on another. when: is how one playbook stays safe and
  portable across hosts. The exam tests it directly — "install X only when
  the distribution is Y" — and it pairs naturally with facts: gather a fact,
  branch on it.

---

HOW TO DO IT

  We install tree with the package module, but guard it with a when: that
  matches only Rocky. Since this control node IS Rocky, the task will run and
  tree ends up installed. Write the playbook:

```run
cd /root/rhce/conditionals
cat > playbook.yml <<'EOF'
---
- name: Install tree only on Rocky
  hosts: managed
  become: true
  tasks:
    - name: Ensure tree is installed on Rocky hosts
      ansible.builtin.package:
        name: tree
        state: present
      when: ansible_distribution == "Rocky"
EOF
cat playbook.yml
```

  when: is a key of the TASK, at the same indent level as the module name —
  not inside the module's arguments. The comparison uses == and a quoted
  string "Rocky". No {{ }} around the fact. Because the play gathers facts by
  default, ansible_distribution is already populated when when: is evaluated.

---

  Run it:

```run
cd /root/rhce/conditionals
ansible-playbook playbook.yml
```

  On Rocky the condition is true, so the task runs: changed=1, tree
  installed. (On, say, an Ubuntu host the same task would show "skipping"
  and the recap would count skipped=1 instead.)

---

  Second run for idempotence — the condition is still true so the task is
  evaluated, but tree is already present so package makes no change:

```run
cd /root/rhce/conditionals
ansible-playbook playbook.yml
```

  changed=0.

---

CHECK IT WORKED

  The grader checks the playbook actually contains a when:, that the run
  succeeds, that tree is installed, and that the second run is idempotent.
  Confirm the package:

```run
rpm -q tree
```

---

GOTCHAS

  - No braces in when:. Writing when: {{ ansible_distribution }} == "Rocky"
    is the number-one conditionals mistake — it may even parse but it's wrong
    style and can misbehave. Bare name only.
  - == compares, = assigns; use the double-equals for the test.
  - String values are case-sensitive: "Rocky" not "rocky". Check the actual
    fact value (as we did above) rather than guessing.
  - when: attaches to the task at module-key indentation. Nest it too deep
    (under the module args) and it silently does the wrong thing.
