THE IDEA

  firewalld keeps two copies of its rules: the RUNTIME config (what's enforced
  right now, lost on reload/reboot) and the PERMANENT config (what comes back
  after a reload). By hand you'd add a rule with --permanent and then --reload.
  In Ansible the module that manages firewalld is:

    ansible.posix.firewalld

  and it exposes both worlds through two booleans: permanent: true writes the
  persistent rule, immediate: true applies it to the running firewall too. Set
  both and you've covered runtime and reboot in one task.

  Note ansible.posix is a separate collection, not part of ansible-core.
  setup.sh best-effort installs it and makes sure firewalld is running, then
  removes the http service so your playbook has work to do. Working directory:
  /root/rhce/firewall/.

---

  Check the starting point — http should not be allowed yet, in either config:

```run
firewall-cmd --query-service=http; firewall-cmd --permanent --query-service=http
```

  Both print `no`. Your job is to turn both into `yes`.

---

WHY IT MATTERS

  "Configure firewall settings" is an RHCSA objective the RHCE wants
  automated. The permanent-vs-runtime split is the number-one firewall trap:
  make a runtime-only change and it evaporates on the next reload; make a
  permanent-only change and nothing happens until you reload. The exam checks
  both states, so a correct answer must satisfy both — which is exactly what
  permanent: true + immediate: true buys you.

---

HOW TO DO IT

  Write the playbook. become: true (firewalld needs root); the task names the
  service and sets state: enabled with both flags:

```run
cd /root/rhce/firewall
cat > playbook.yml <<'EOF'
---
- name: Allow http through the firewall
  hosts: managed
  become: true
  tasks:
    - name: Permit http service permanently and immediately
      ansible.posix.firewalld:
        service: http
        state: enabled
        permanent: true
        immediate: true
EOF
```

  state: enabled means "this rule should be present" (state: disabled would
  remove it). permanent writes it to the on-disk zone; immediate pushes it
  into the live firewall so you don't need a separate reload task.

---

  Run it:

```run
cd /root/rhce/firewall && ansible-playbook playbook.yml
```

  changed=1 on the first pass. Now the idempotence check — run again:

```run
cd /root/rhce/firewall && ansible-playbook playbook.yml
```

  changed=0: http is already allowed in both configs, so the module does
  nothing.

---

CHECK IT WORKED

  The grader queries both the runtime and permanent configs, just like you did
  at the start:

```run
firewall-cmd --query-service=http; firewall-cmd --permanent --query-service=http
```

  Both should now say `yes`.

---

GOTCHAS

  - Both flags. permanent: true alone leaves the running firewall unchanged
    until a reload; immediate: true alone is lost on reboot. The grader checks
    each config separately, so you need both true.
  - Use the fully-qualified name ansible.posix.firewalld. If the collection
    isn't installed, `ansible-galaxy collection install ansible.posix` fixes
    it (setup.sh already tried).
  - Use service: http, not port: 80/tcp — the task and grader are written
    around the named service.
  - Don't confuse state: enabled (rule present) with the service module's
    state — different module, different meaning.
