Work in /opt/rhce/facts/. Write `playbook.yml` that runs against the `managed`
group and uses gathered facts to write `/etc/issue` so that it contains a single
rendered line:

    Host: <hostname> OS: <distribution>

using the facts `ansible_hostname` and `ansible_distribution` (for example, on this
host it renders to `Host: server1 OS: Rocky`). Then run it with `ansible-playbook`.
Your playbook must be idempotent (a second run changes nothing).
