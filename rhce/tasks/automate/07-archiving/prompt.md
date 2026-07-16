Work in /opt/rhce/archiving/. Write `playbook.yml` that uses the `archive` module
to create a gzip-compressed tar archive of the directory `/etc/ssh` at
`/opt/rhce/archiving/etc-backup.tar.gz` on the hosts in the `managed` group.

Run it with `ansible-playbook`. The archive should be a valid `.tar.gz` that
contains the SSH configuration.
