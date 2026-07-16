THE IDEA

  SELinux booleans are on/off switches that toggle a chunk of policy without
  writing custom rules — for example, letting Apache open outbound network
  connections. By hand you'd run setsebool -P; the -P makes it persistent. The
  Ansible module is:

    ansible.posix.seboolean

  with name:, state: (true/false = on/off), and persistent: true — which is
  the module's equivalent of -P. This task turns on
  httpd_can_network_connect persistently.

  seboolean is in the ansible.posix collection (setup.sh installs it), and
  setup.sh has turned the boolean off first. Working directory:
  /opt/rhce/selinux/.

---

  Check the boolean's current value — it should be off:

```run
getsebool httpd_can_network_connect
```

  You'll see `httpd_can_network_connect --> off`. Your playbook flips it on
  and makes that stick.

---

WHY IT MATTERS

  On RHEL, SELinux is enforcing by default, and the "fix" for many blocked
  services is flipping the right boolean rather than disabling SELinux. Doing
  it persistently is the whole point — a runtime-only flip reverts on reboot.
  The exam objective is managing SELinux, and the grader checks both the
  current value AND (via semanage, if present) that the persistent default was
  flipped on.

---

HOW TO DO IT

  Write the playbook. become: true (changing policy needs root); persistent:
  true is the key attribute:

```run
cd /opt/rhce/selinux
cat > playbook.yml <<'EOF'
---
- name: Enable an SELinux boolean persistently
  hosts: managed
  become: true
  tasks:
    - name: Allow httpd to make network connections
      ansible.posix.seboolean:
        name: httpd_can_network_connect
        state: true
        persistent: true
EOF
```

  state: true switches the boolean on; persistent: true writes it to the
  on-disk policy so it survives a reboot (exactly what setsebool -P does).
  Leave persistent off and you'd only change the running value.

---

  Run it:

```run
cd /opt/rhce/selinux && ansible-playbook playbook.yml
```

  changed=1. Now re-run for the idempotence check:

```run
cd /opt/rhce/selinux && ansible-playbook playbook.yml
```

  changed=0 — the boolean is already on both at runtime and persistently, so
  the module does nothing.

---

CHECK IT WORKED

  The grader checks the live value with getsebool and the persistent default
  with semanage. Confirm both:

```run
getsebool httpd_can_network_connect
semanage boolean -l 2>/dev/null | grep '^httpd_can_network_connect' || echo "(semanage not installed)"
```

  getsebool should now say `on`, and the semanage line should show the state
  as (on , ...) — the persistent default flipped on.

---

GOTCHAS

  - persistent: true is essential. Without it the change is runtime-only and
    reverts on reboot, and the semanage persistence check would fail.
  - state takes a boolean: true/false (or yes/no). It's on/off, not
    present/absent like some other modules.
  - Get the boolean name right — httpd_can_network_connect. A typo'd boolean
    name makes the module fail.
  - This needs a working SELinux and the policycoreutils tools; on a box with
    SELinux disabled the module can't do its job. On the exam SELinux is
    enforcing, which is the assumed environment.
