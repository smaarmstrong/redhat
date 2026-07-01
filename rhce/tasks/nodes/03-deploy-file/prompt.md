Work in /root/rhce/deploy-file/. Write `playbook.yml` that deploys a file to the
hosts in the `managed` group: create `/etc/motd` containing exactly the line

    Managed by Ansible

(a single line followed by a trailing newline) using the `ansible.builtin.copy`
module. Run it with `ansible-playbook`. Your playbook must be idempotent (a second
run changes nothing).
