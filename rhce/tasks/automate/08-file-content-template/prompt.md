Work in /root/rhce/motd-content/. Write `playbook.yml` that manages `/etc/motd` on
the hosts in the `managed` group using the `copy` module with its `content:` option
fed from a variable.

- Define a variable (e.g. `motd_text`) holding a two-line message.
- Use `copy` with `content: "{{ motd_text }}"` to write it to `/etc/motd`.

The resulting `/etc/motd` must contain exactly these two lines:

```
Authorized access only.
Managed by Ansible.
```

Run it with `ansible-playbook`. Your playbook must be idempotent (a second run
changes nothing).
