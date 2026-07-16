Work in /opt/rhce/file-content/. Write `playbook.yml` that manages the content of
`/etc/security/limits.d/99-custom.conf` on the hosts in the `managed` group:

- Use the `lineinfile` module to ensure the file contains this exact line:
  `* soft nofile 4096`
- Use the `blockinfile` module to add a managed block of your own content to the
  same file (this inserts the standard `# BEGIN ANSIBLE MANAGED BLOCK` /
  `# END ANSIBLE MANAGED BLOCK` markers).

Run it with `ansible-playbook`. Your playbook must be idempotent (a second run
changes nothing).
