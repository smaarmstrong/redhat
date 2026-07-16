Work in /opt/rhce/services/. Write `playbook.yml` targeting the `managed` group
that ensures the `chronyd` service is both **enabled** (starts at boot) and
**started** (running now), using the `ansible.builtin.service` (or `systemd`)
module. Run it with `ansible-playbook`. Your playbook must be idempotent (a second
run changes nothing).
