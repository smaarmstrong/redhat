Work in /opt/rhce/cron/. Write `playbook.yml` targeting the `managed` group that
uses the `ansible.builtin.cron` module to create a **root** cron job named
`nightly-backup` that runs `/usr/local/bin/backup.sh` every day at **02:15**
(minute 15, hour 2). Run it with `ansible-playbook`. Your playbook must be
idempotent (a second run changes nothing).
