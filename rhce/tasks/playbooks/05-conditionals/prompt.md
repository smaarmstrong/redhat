Work in /opt/rhce/conditionals/. Write `playbook.yml` that runs against the
`managed` group and installs the `tree` package ONLY when the host's
`ansible_distribution` fact equals `Rocky` (use a `when:` conditional). Then run
it with `ansible-playbook`. Since this control node is Rocky, `tree` must end up
installed. Your playbook must be idempotent (a second run changes nothing).
