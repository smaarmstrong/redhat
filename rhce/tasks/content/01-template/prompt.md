Work in /root/rhce/template-motd/. Create a Jinja2 template
`templates/motd.j2` that renders exactly one line:

    Welcome to {{ ansible_hostname }} running {{ ansible_distribution }} {{ ansible_distribution_version }}

Then write a playbook `playbook.yml` (targeting the `managed` group) that uses
the `template` module to render `templates/motd.j2` to `/etc/motd`, and run it
with `ansible-playbook`. Facts must be gathered so the variables resolve. Your
playbook must be idempotent (a second run changes nothing).
