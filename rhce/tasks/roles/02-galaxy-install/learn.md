THE IDEA

  You don't have to write every role yourself. Ansible Galaxy is a public
  registry of community roles — someone has almost certainly already
  written and battle-tested the role you need (NTP, nginx, PostgreSQL...).
  You pull one down with the ansible-galaxy command.

  The professional way isn't to install roles one-by-one from memory; it's
  to declare your dependencies in a file, requirements.yml, and install
  them all from it. That file is checked into your project, so anyone (or
  any CI job) can reproduce the exact same set of roles:

    ---
    roles:
      - name: geerlingguy.ntp

  The install command reads that file and drops each role into a directory
  you choose:

    ansible-galaxy role install -r requirements.yml -p roles

  Here `-r` is the requirements file and `-p roles` puts them under the
  project's roles/ directory.

---

  Heads up: this is the one BONUS task that needs internet access to
  galaxy.ansible.com. If the practice box has no network, the download
  step will fail — that's expected, and the grader notes it rather than
  penalising you. Let's check reachability first:

```run
curl -fsI --max-time 5 https://galaxy.ansible.com/ >/dev/null 2>&1 && echo "Galaxy reachable" || echo "no network to Galaxy — install step will not complete"
```

---

WHY IT MATTERS

  "Install roles from Ansible Galaxy and use them" is an RHCE objective.
  Knowing requirements.yml is the difference between a reproducible project
  and a pile of manually-fetched roles. On the exam the pattern is always:
  write requirements.yml, run ansible-galaxy install, then reference the
  role in a play.

---

HOW TO DO IT

  Your working directory is /opt/rhce/galaxy-install, with a roles/
  directory ready and roles_path = roles in ansible.cfg.

  Step 1 — declare the dependency. Write requirements.yml naming the role
  geerlingguy.ntp (author.rolename is Galaxy's naming scheme):

```run
cd /opt/rhce/galaxy-install
cat > requirements.yml <<'REQ'
---
roles:
  - name: geerlingguy.ntp
REQ
```

---

  Step 2 — install from the requirements file into ./roles. If the box is
  online this downloads the role and its metadata; if it's offline it will
  report a network error, which is fine for this bonus task:

```run
cd /opt/rhce/galaxy-install
ansible-galaxy role install -r requirements.yml -p roles
```

---

CHECK IT WORKED

  A successful install leaves a full role tree under roles/. The grader
  checks the directory exists and has a tasks/main.yml:

```run
ls -la /opt/rhce/galaxy-install/roles/geerlingguy.ntp 2>/dev/null || echo "not installed (likely no network)"
```

  You can also list what ansible-galaxy knows is installed under this path:

```run
cd /opt/rhce/galaxy-install
ansible-galaxy role list -p roles
```

  Once installed, you'd use it exactly like a local role — add it under a
  play's `roles:` key (roles: - geerlingguy.ntp) and Ansible finds it via
  roles_path.

---

GOTCHAS

  - -r vs -p. -r is the requirements FILE to read; -p is the PATH to
    install into. Swapping them is a common slip.
  - It's `ansible-galaxy role install`. For collections the subcommand is
    `collection install` and the requirements file uses a `collections:`
    key instead — don't confuse the two.
  - Galaxy needs the internet. In an air-gapped exam or lab this simply
    can't complete; that's why it's flagged as a bonus and the grader
    degrades gracefully.
  - Commit requirements.yml, not the downloaded roles. The whole point is
    that anyone can re-run the install and get the same roles.
