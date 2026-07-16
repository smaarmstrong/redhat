THE IDEA

  A handler is a special task that only runs when something else tells it to.
  You define it once under a handlers: section, give it a name, and then a
  regular task "notifies" it. The handler runs only if that task actually
  CHANGED something — and even if ten tasks notify it, it runs just once, at
  the very END of the play.

  The classic pattern: a task rewrites a service's config file; if (and only
  if) the file changed, notify a handler that reloads the service. No change,
  no reload — which is exactly the behaviour you want.

---

  Confirm the starting state — neither the config nor the marker exists yet:

```run
ls -l /etc/myapp.conf /opt/rhce/handlers/reloaded.marker 2>&1 || true
```

---

WHY IT MATTERS

  Handlers are how Ansible avoids needless restarts. Bouncing a service on
  every single run — even when nothing changed — is disruptive and breaks the
  spirit of idempotence. "Change config, notify handler to reload" is one of
  the most common real playbook patterns and a guaranteed exam topic. The
  subtle part it tests: the handler must fire on the first run and NOT fire on
  the second.

---

HOW TO DO IT

  We write /etc/myapp.conf with the copy module and add notify: to that task,
  naming the handler. Then we define that handler under handlers:, where it
  touches the marker file. Write the playbook:

```run
cd /opt/rhce/handlers
cat > playbook.yml <<'EOF'
---
- name: Write config and notify a handler
  hosts: managed
  become: true
  tasks:
    - name: Deploy the application config
      ansible.builtin.copy:
        dest: /etc/myapp.conf
        content: "enabled = true\n"
      notify: reload myapp
  handlers:
    - name: reload myapp
      ansible.builtin.file:
        path: /opt/rhce/handlers/reloaded.marker
        state: touch
EOF
cat playbook.yml
```

  Two things bind together here. notify: reload myapp on the task must match
  the handler's name: reload myapp EXACTLY — that string is the link. And
  handlers: is a section of the PLAY, at the same level as tasks:, not nested
  inside a task. The handler uses the file module with state: touch to create
  the marker.

---

  Run it. The config file is new, so the task changes, so the handler is
  notified and runs:

```run
cd /opt/rhce/handlers
ansible-playbook playbook.yml
```

  Read the tail of the output: after the tasks you'll see a RUNNING HANDLER
  line for "reload myapp". That only appears because the copy task reported
  changed. The recap shows changed=2 (the copy and the handler).

---

  Now the important second run. The config file already has the right
  content, so the copy task is unchanged, so nothing notifies the handler and
  it stays silent:

```run
cd /opt/rhce/handlers
ansible-playbook playbook.yml
```

  No RUNNING HANDLER section this time, and the recap shows changed=0. That's
  the behaviour the grader checks — handler fires once, then never again while
  nothing changes.

---

CHECK IT WORKED

  The grader confirms /etc/myapp.conf exists, the marker exists (so the
  handler fired on run one), the playbook defines a notified handler, and the
  second run reports changed=0. See both files:

```run
cat /etc/myapp.conf
ls -l /opt/rhce/handlers/reloaded.marker
```

---

GOTCHAS

  - The notify string and the handler name must match character-for-
    character. A typo means the notify silently goes nowhere and the handler
    never runs — no error, just no action.
  - handlers: is a play-level section, aligned with tasks:. Putting it inside
    a task is the usual structural mistake.
  - Handlers run at the END of the play, not immediately after the notifying
    task. If you need the effect mid-play, that's what meta: flush_handlers
    is for — but you rarely need it here.
  - A handler only fires when the notifying task reports changed. If your
    config task is somehow always "ok", the handler never runs.
