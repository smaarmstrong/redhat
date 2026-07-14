THE IDEA

  On the RHCE exam you don't fix a box by hand — you describe the state you
  want in a YAML file called a playbook, and Ansible makes the machine match
  it. This task is the classic RHCSA-in-Ansible pair: define a package
  repository, then install a package from it.

  A playbook is a list of "plays". A play targets a group of hosts and runs a
  list of "tasks" on them. Each task calls one module — a small unit of work
  like "define a repo" or "install a package". Two modules do the whole job
  here:

    ansible.builtin.yum_repository  writes an /etc/yum.repos.d/*.repo file
    ansible.builtin.package         installs/removes packages (dnf under the hood)

  setup.sh has already made your working directory at
  /root/rhce/packages-repo/ with an ansible.cfg (points at the inventory) and
  an inventory file defining the `managed` group. Let's look.

---

  Change into the working directory and see what setup left you:

```run
cd /root/rhce/packages-repo && cat ansible.cfg inventory
```

  The ansible.cfg says "use the file called inventory", and the inventory puts
  one host — localhost, connected locally — into a group named `managed`. Your
  playbook will target that group. On the real exam `managed` would be remote
  machines over SSH; here it's the local box, but the playbook is identical.

---

WHY IT MATTERS

  "Automate common RHCSA tasks with Ansible" is the whole first objective
  domain of EX294. Anything you learned to do by hand for RHCSA — repos,
  services, users, firewall — you must now express as an idempotent playbook.
  Idempotent means running it twice is safe: the first run changes things, the
  second reports changed=0 because the system already matches. That's the
  behaviour the grader checks, and it's the point of configuration management.

---

HOW TO DO IT

  We'll write the playbook with a heredoc so the YAML lands exactly right.
  Read the structure as it goes by: three dashes start a YAML document; the
  play has a name, hosts: managed, and become: true (run as root via sudo,
  needed to write repo files and install packages); then a tasks: list.

```run
cd /root/rhce/packages-repo
cat > playbook.yml <<'EOF'
---
- name: Configure repo and install tree
  hosts: managed
  become: true
  tasks:
    - name: Define the localdvd repository
      ansible.builtin.yum_repository:
        name: localdvd
        description: Local DVD BaseOS
        baseurl: file:///mnt/dvd/BaseOS
        gpgcheck: false
        enabled: true

    - name: Ensure tree is installed
      ansible.builtin.package:
        name: tree
        state: present
EOF
```

  The yum_repository module's `name:` becomes the repo id in square brackets
  — [localdvd] — and the file it writes is /etc/yum.repos.d/localdvd.repo.
  baseurl and gpgcheck: false map straight onto the lines the grader greps
  for. The package task just says "state: present" — Ansible installs tree
  only if it isn't already there.

---

  Run it the way the exam expects — with ansible-playbook. It reads ansible.cfg
  in the current directory, finds the inventory, and applies the play:

```run
cd /root/rhce/packages-repo && ansible-playbook playbook.yml
```

  Watch the PLAY RECAP at the bottom. You should see ok=N changed=2 (the repo
  got defined and tree got installed) failed=0.

---

  Now prove idempotence — run the very same playbook again:

```run
cd /root/rhce/packages-repo && ansible-playbook playbook.yml
```

  This time changed=0. Nothing changed because the system already matches what
  the playbook describes. That green "no changes" run is what separates a real
  Ansible answer from a shell script, and the grader explicitly re-runs to
  check for it.

---

CHECK IT WORKED

  The grader confirms the repo file and its contents, then that tree is
  installed. Look at what your playbook produced:

```run
cat /etc/yum.repos.d/localdvd.repo
rpm -q tree
```

  You should see [localdvd], the file:///mnt/dvd/BaseOS baseurl, gpgcheck=0,
  and rpm reporting a tree version. That's every check satisfied.

---

GOTCHAS

  - The repo id is the module's `name:`, not the filename you might imagine.
    name: localdvd gives you both [localdvd] and localdvd.repo.
  - gpgcheck must be off; the grader accepts 0, no, or false.
  - Use ansible.builtin.package (or dnf) with state: present, never a raw
    `command: dnf install tree` — a shell command isn't idempotent and misses
    the point of the objective.
  - Keep YAML indentation with spaces, never tabs, and keep it consistent —
    the syntax check fails on a stray tab or a misaligned key.
