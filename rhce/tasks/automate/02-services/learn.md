THE IDEA

  Managing a systemd service by hand is two verbs: enable it (so it starts at
  every boot) and start it (so it's running right now). In Ansible one module
  does both in a single task:

    ansible.builtin.service   name + enabled: true + state: started

  There's also ansible.builtin.systemd_service (formerly systemd) with the
  same idea; `service` is the generic wrapper and is all this task needs.

  This task's target is chronyd, the NTP time-sync daemon. setup.sh has
  deliberately disabled and stopped it, so there's real work for your playbook
  to do. Your working directory /opt/rhce/services/ already has ansible.cfg
  and an inventory with the `managed` group.

---

  Confirm the starting state — chronyd should be down and disabled:

```run
systemctl is-enabled chronyd; systemctl is-active chronyd
```

  You'll see something like `disabled` and `inactive`. Those are the two facts
  your playbook has to flip, and the two facts the grader checks.

---

WHY IT MATTERS

  "Start and enable services" is a core RHCSA skill, and the exam wants it done
  the Ansible way. The classic real-world mistake is starting a service but
  forgetting to enable it — it runs fine until the next reboot, then vanishes.
  One task covering both verbs is how you avoid that, and enabled + started
  together are exactly the two grader checks.

---

HOW TO DO IT

  Write the playbook. One play, become: true (managing systemd needs root),
  one task calling the service module with both attributes:

```run
cd /opt/rhce/services
cat > playbook.yml <<'EOF'
---
- name: Enable and start chronyd
  hosts: managed
  become: true
  tasks:
    - name: Ensure chronyd is enabled and running
      ansible.builtin.service:
        name: chronyd
        enabled: true
        state: started
EOF
```

  enabled: true handles boot persistence; state: started handles "running
  now". If chronyd were already up, state: started would simply confirm it —
  the module reports changed only when it actually has to act.

---

  Run it with ansible-playbook:

```run
cd /opt/rhce/services && ansible-playbook playbook.yml
```

  The recap should show changed=1 — one task did work (enable + start). Now
  run it again to see idempotence:

```run
cd /opt/rhce/services && ansible-playbook playbook.yml
```

  changed=0 this time: chronyd is already enabled and running, so there's
  nothing to do.

---

CHECK IT WORKED

  The grader asks systemd the same two questions you saw at the start — this
  time expecting the opposite answers:

```run
systemctl is-enabled chronyd; systemctl is-active chronyd
```

  `enabled` and `active` — both flipped, task complete.

---

GOTCHAS

  - Set BOTH enabled and state. enabled alone won't start it now; state:
    started alone won't survive a reboot. The grader checks each separately.
  - state values: use `started` (idempotent, "make sure it's running"), not
    `restarted` (which acts every single run and breaks idempotence).
  - become: true is required — an ordinary user can't enable or start a system
    service.
