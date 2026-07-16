THE IDEA

  Ansible never guesses which machines to manage — you tell it, in an
  inventory. The simplest kind is a "static" inventory: a plain text
  file listing hostnames, optionally sorted into named groups. A group
  is just a label you can aim a play at ("run this on all
  webservers"), and groups can even contain other groups.

  The classic format is INI-style. A line in square brackets starts a
  group; the bare hostnames under it are that group's members:

    [webservers]
    node1.example.com
    node2.example.com

---

  Let's look at where we're working. The setup already dropped an
  ansible.cfg here that points Ansible at a file literally called
  `inventory`, so that's the filename we must create.

```run
cd /opt/rhce/static-inventory && ls -la && cat ansible.cfg
```

  Right now there's no inventory file yet — that's the whole job.

---

WHY IT MATTERS

  The inventory is the foundation every play stands on. On the exam
  you'll be told to target groups like `webservers` or `database`, and
  if those groups don't exist (or contain the wrong hosts) every task
  that depends on them fails. Getting groups — and parent/child groups
  — right is a graded skill in its own right.

  The parent group is the interesting bit. A group whose members are
  other groups uses the special `:children` suffix. That lets you say
  "production = everything in webservers plus everything in dbservers"
  without retyping any hostnames.

---

HOW TO DO IT

  We need three groups:

    webservers   node1.example.com, node2.example.com
    dbservers    node3.example.com
    production   a PARENT of webservers and dbservers

  Write the whole file in one shot with a heredoc. Note the
  [production:children] header — under it you list group NAMES, not
  hostnames:

```run
cd /opt/rhce/static-inventory
cat > inventory <<'INV'
[webservers]
node1.example.com
node2.example.com

[dbservers]
node3.example.com

[production:children]
webservers
dbservers
INV
```

  That's it. The hosts don't have to be reachable — we're only
  defining structure, not connecting to anything.

---

CHECK IT WORKED

  Never eyeball an inventory and hope. Ansible ships a tool that parses
  it and shows you the resolved structure — the same tool the grader
  uses. Ask it for the full picture:

```run
cd /opt/rhce/static-inventory && ansible-inventory -i inventory --list
```

  Look for node1/node2 under webservers, node3 under dbservers, and a
  `production` entry whose "children" are webservers and dbservers. A
  friendlier tree view of the same thing:

```run
cd /opt/rhce/static-inventory && ansible-inventory -i inventory --graph
```

  If `ansible-inventory` prints without error, the file parses — that's
  the second thing the grader checks.

---

GOTCHAS

  - Under a [name:children] header you list GROUP names, not
    hostnames. Putting node1.example.com there is the classic mistake.
  - The section header must match exactly: [production:children], not
    [production] with children mixed in.
  - Blank lines between groups are fine and aid readability; a hostname
    with no [group] header above it lands in the implicit "ungrouped"
    group, which is usually not what you want.
  - The file just needs to be named `inventory` here because ansible.cfg
    says so; on the exam always create the exact filename you're told.
