THE IDEA

  Before a play runs its tasks, Ansible quietly interrogates each target
  machine and collects a big dictionary of information about it — the OS, the
  hostname, IP addresses, memory, mounted disks, and much more. Those are
  "facts". Because they're discovered fresh at run time, they let one
  playbook adapt to whatever host it lands on.

  Facts are just variables, so you reference them the same way — in
  {{ curly braces }}. Two you'll use constantly:

    ansible_hostname       the machine's short hostname
    ansible_distribution   the OS name, e.g. Rocky, RedHat, Ubuntu

---

  You can see the facts for yourself. This is the fact-gathering step run on
  its own — it prints the whole dictionary:

```run
cd /root/rhce/facts
ansible managed -m ansible.builtin.setup
```

  That's a lot. Scroll and you'll spot ansible_hostname and
  ansible_distribution in there among hundreds of others. In a playbook you
  don't run setup by hand — gathering happens automatically at the start of
  the play (unless you turn it off).

---

WHY IT MATTERS

  Facts are how playbooks make decisions and fill in host-specific values
  without you hard-coding them: "install the right package for THIS distro",
  "write a banner naming THIS host". The exam loves tasks phrased as "using
  facts, render a file that contains the hostname and OS" — exactly this one.
  It's proving you know facts exist and how to reach into them.

---

HOW TO DO IT

  We want /etc/issue to hold one line: "Host: <hostname> OS: <distribution>".
  We build that line with a Jinja2 template string mixing literal text and
  two facts. Write the playbook:

```run
cd /root/rhce/facts
cat > playbook.yml <<'EOF'
---
- name: Render facts into /etc/issue
  hosts: managed
  become: true
  tasks:
    - name: Write host and OS facts
      ansible.builtin.copy:
        dest: /etc/issue
        content: "Host: {{ ansible_hostname }} OS: {{ ansible_distribution }}\n"
EOF
cat playbook.yml
```

  There's no vars: block — the facts are already available because the play
  gathers them by default. The content: string interleaves plain words
  ("Host: ", " OS: ") with two {{ fact }} references, and copy writes the
  rendered result. become: true is needed because /etc/issue is
  root-owned. The whole value is quoted because it contains {{ and spaces.

---

  Run it:

```run
cd /root/rhce/facts
ansible-playbook playbook.yml
```

  Notice the very first line of output: "Gathering Facts". That's the step
  that populates ansible_hostname and ansible_distribution before your task
  runs. Recap shows changed=1 on the first pass.

---

  Second run proves idempotence — copy sees the file already holds the same
  rendered line and does nothing:

```run
cd /root/rhce/facts
ansible-playbook playbook.yml
```

  changed=0.

---

CHECK IT WORKED

  The grader looks for "Host: <this host>" and "OS: Rocky" in /etc/issue,
  plus the idempotent second run. See the rendered file:

```run
cat /etc/issue
```

  Confirm the hostname it printed matches the box:

```run
hostname -s
```

---

GOTCHAS

  - If you disable gathering (gather_facts: false), ansible_hostname and
    friends won't exist and the task fails with an undefined-variable error.
    Leave gathering on for fact-based tasks.
  - Fact names are case- and spelling-exact: ansible_distribution, not
    ansible_distro or ansible_Distribution.
  - There's a newer syntax, ansible_facts['hostname'], for the same data.
    Either works; the ansible_hostname short form is fine and is what this
    task expects.
  - Quote the content string — it starts with plain text here, but it holds
    {{ }} and colons, so quoting keeps YAML happy.
