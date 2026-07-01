Work in /root/rhce/firewall/. Write `playbook.yml` targeting the `managed` group
that uses the `ansible.posix.firewalld` module to permanently allow the `http`
service in the default zone, applying the change **both** to the permanent
configuration and immediately to the running firewall. Run it with
`ansible-playbook`. Your playbook must be idempotent (a second run changes
nothing).

Hint: `ansible.posix.firewalld` needs `permanent: true` and `immediate: true`
(with `state: enabled`) to satisfy both requirements.

Note: the `ansible.posix` collection is not part of `ansible-core`. If it is not
already present, install it, e.g. `ansible-galaxy collection install ansible.posix`
(or use your local RHEL AppStream collection RPM).
