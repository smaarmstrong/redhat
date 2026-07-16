Work in /opt/rhce/create-role/. Create a role named `webconfig` under `roles/`
that deploys a configuration file:

  • the role must have the standard directory structure, including
    `roles/webconfig/tasks/main.yml`
  • applying the role must create `/etc/myapp/app.conf` (deploy it from the
    role's `files/` with the copy module, or render it from a template)

Then write a playbook `site.yml` that applies the `webconfig` role to the hosts
in the `managed` group, and run it with `ansible-playbook`. Your role must be
idempotent (a second run changes nothing).
