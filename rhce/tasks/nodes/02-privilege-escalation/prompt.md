Work in /root/rhce/privilege-escalation/. The user `ansible` already exists on the
hosts in the `managed` group.

Write `playbook.yml` that configures **passwordless sudo** for the `ansible` user by
deploying a drop-in file under `/etc/sudoers.d/`. The file must grant:

    ansible ALL=(ALL) NOPASSWD: ALL

Deploy it with a module that **validates** the sudoers syntax before installing it
(use `validate: 'visudo -cf %s'` with `ansible.builtin.copy`). Run the playbook with
`ansible-playbook`. Your playbook must be idempotent (a second run changes nothing).
