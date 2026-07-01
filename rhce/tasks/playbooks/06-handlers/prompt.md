Work in /root/rhce/handlers/. Write `playbook.yml` that runs against the `managed`
group and:

  • writes a configuration file `/etc/myapp.conf` (any content is fine), and
  • when that file changes, NOTIFIES a handler that creates the marker file
    `/root/rhce/handlers/reloaded.marker`.

Then run it with `ansible-playbook`. On the first run both the config file and the
marker must exist (the handler fired). Your playbook must be idempotent: a second
run reports `changed=0` and the handler does NOT fire again.
