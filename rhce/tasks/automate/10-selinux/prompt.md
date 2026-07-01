Work in /root/rhce/selinux/. Write `playbook.yml` that uses the
`ansible.posix.seboolean` module to enable the `httpd_can_network_connect`
SELinux boolean **persistently** on the hosts in the `managed` group (so it
survives a reboot).

Run it with `ansible-playbook`. Your playbook must be idempotent (a second run
changes nothing).
