THE IDEA

  Variables let a play adapt to different hosts without hard-coding
  values. You could jam them into the inventory file next to each host,
  but that gets messy fast. The clean, recommended way is group_vars: a
  directory of files, one per group, that Ansible loads automatically.

  The rule is a naming convention. Beside your inventory (or playbook),
  create a directory called group_vars, and inside it a file whose NAME
  matches a group name:

    group_vars/webservers      <- variables for the webservers group

  Every host in that group inherits those variables — no edits to the
  inventory needed.

---

  Look at what setup gave us: an inventory with a webservers group, and
  ansible.cfg pointing at it. There's no group_vars yet.

```run
cd /root/rhce/inventory-vars && ls -la && cat inventory
```

---

WHY IT MATTERS

  Separating data (variables) from structure (inventory) and logic
  (playbooks) is core Ansible design, and the exam tests it directly.
  You'll be told to define a variable "for the webservers group" or
  "for host X" without touching other files — and the grader checks the
  variable resolves for the right hosts. Knowing that group_vars/<group>
  and host_vars/<host> are magic directory names, loaded by filename, is
  the whole trick.

  Our task: give the webservers group a variable http_port = 8080,
  using group_vars — and specifically NOT by editing the inventory.

---

HOW TO DO IT

  Make the group_vars directory and drop in a file named exactly
  `webservers` (matching the group). Its contents are just YAML
  key: value pairs:

```run
cd /root/rhce/inventory-vars
mkdir -p group_vars
cat > group_vars/webservers <<'GV'
---
http_port: 8080
GV
```

  That's all. Because node1.example.com is a member of webservers, it
  now inherits http_port = 8080. We never opened the inventory file.

---

CHECK IT WORKED

  Ask ansible-inventory to show the variables it resolves for the host —
  this is precisely what the grader does:

```run
cd /root/rhce/inventory-vars && ansible-inventory -i inventory --host node1.example.com
```

  In that JSON you should see "http_port": 8080. If it's there, the
  group_vars file is being found and applied to the group's members.

---

GOTCHAS

  - The filename must match the group name EXACTLY: group_vars/webservers
    for the webservers group. group_vars/webserver (singular) or a .yml
    typo means Ansible silently loads nothing.
  - Location matters. group_vars/ must sit next to the inventory (or the
    playbook). Here that's the working directory — good.
  - The value 8080 is a YAML integer; don't quote it unless you actually
    want the string "8080".
  - A group_vars file MAY end in .yml/.yaml, but a bare name (no
    extension) works too and is common — either is fine as long as the
    base name matches the group.
  - group_vars is for groups; the sibling host_vars/<hostname> does the
    same job for a single host.
