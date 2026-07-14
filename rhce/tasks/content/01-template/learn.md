THE IDEA

  The copy module writes a fixed file. But most config files aren't fixed
  — they need this host's name, this host's IP, this OS version baked in.
  For that you use a TEMPLATE: a file written in Jinja2, the templating
  language Ansible speaks, with {{ placeholders }} that get filled in per
  host at deploy time.

  The template module renders a .j2 file through Jinja2 (substituting
  variables and Ansible facts) and writes the result to the destination on
  each managed node. Same template, different output on every host — which
  is exactly what you want for a customised config.

  The placeholders here are Ansible FACTS — data Ansible auto-discovers
  about each node:

    {{ ansible_hostname }}              the short hostname
    {{ ansible_distribution }}          e.g. Rocky
    {{ ansible_distribution_version }}  e.g. 9.4

---

  Your working directory is /root/rhce/template-motd, which already has a
  templates/ subdirectory (the conventional home for .j2 files). The
  `managed` group is localhost. setup blanked /etc/motd:

```run
cat /etc/motd; echo "--- (empty above) ---"
```

---

WHY IT MATTERS

  "Create and use templates to create customized configuration files" is a
  headline RHCE objective, and templates show up all over the exam — sshd
  configs, web server vhosts, motd banners. The key insight the exam tests
  is that facts must be GATHERED for the variables to resolve; a template
  that references ansible_hostname will fail if fact-gathering is off.

---

HOW TO DO IT

  Step 1 — write the Jinja2 template. It's just text with {{ }} markers.
  One line, rendered per host:

```run
cd /root/rhce/template-motd
cat > templates/motd.j2 <<'J2'
Welcome to {{ ansible_hostname }} running {{ ansible_distribution }} {{ ansible_distribution_version }}
J2
```

---

  Step 2 — write the playbook. It targets managed, becomes root (writing
  under /etc), and — importantly — gathers facts so those variables have
  values. The template module takes src (the .j2) and dest (where the
  rendered file goes):

```run
cd /root/rhce/template-motd
cat > playbook.yml <<'PB'
---
- name: Render MOTD from a template
  hosts: managed
  become: true
  gather_facts: true
  tasks:
    - name: Deploy /etc/motd
      ansible.builtin.template:
        src: templates/motd.j2
        dest: /etc/motd
        mode: '0644'
PB
```

  Run it:

```run
cd /root/rhce/template-motd
ansible-playbook playbook.yml
```

---

CHECK IT WORKED

  Look at /etc/motd — the placeholders should now be this machine's REAL
  hostname and OS, not literal {{ }}:

```run
cat /etc/motd
```

  That's what the grader checks: that the file contains the actual short
  hostname and mentions Rocky. If you still see {{ ansible_hostname }} in
  there, facts weren't gathered.

  Now confirm idempotency — a second run should report changed=0, because
  template compares the rendered result against what's already on disk:

```run
cd /root/rhce/template-motd
ansible-playbook playbook.yml
```

---

GOTCHAS

  - gather_facts must be on (it's the default, but don't turn it off here).
    Without facts, ansible_hostname and friends are undefined and the play
    errors out.
  - template renders through Jinja2; copy does not. If you use copy on a
    .j2 file you'll deploy the literal {{ }} text — a classic mistake.
  - src is the template, dest is the output. src points at the .j2 on the
    control node; dest is the path on the managed node.
  - Idempotency is by rendered content. If the facts don't change, the
    output doesn't change, so the second run is changed=0 — no extra work
    needed.
