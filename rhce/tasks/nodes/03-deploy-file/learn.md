THE IDEA

  A huge fraction of real Ansible work is just "put this file here, with
  these permissions". The workhorse for that is the copy module. It can
  push a file from your control node OUT to the managed nodes, or — as
  here — write literal text you hand it inline.

  The magic word is `content:`. Instead of pointing copy at a source file,
  you give it a string, and copy writes exactly that string to `dest:` on
  every target host. Perfect for small, fixed files like a message-of-the-
  day banner.

  In this task you write /etc/motd containing one line:

    Managed by Ansible

  A single line WITH a trailing newline — which is why the content string
  ends in \n.

---

  Your working directory is /root/rhce/deploy-file; the inventory's
  `managed` group is localhost. setup blanked /etc/motd so you start
  clean:

```run
wc -c /etc/motd
```

  Zero bytes right now. Let's fill it.

---

WHY IT MATTERS

  "Deploy files to managed nodes" is a core objective, and copy is the
  first tool you reach for. The exam loves it because it exercises two
  ideas at once: getting content onto a host, AND doing it idempotently —
  the second run must report no change. copy gives you that automatically
  because it compares the file's checksum before writing.

---

HOW TO DO IT

  Write a playbook that targets the managed group, becomes root (you're
  writing under /etc), and uses copy with an inline content string. Note
  the explicit \n so the file ends in a newline, and mode 0644 so it's
  world-readable like a normal motd:

```run
cd /root/rhce/deploy-file
cat > playbook.yml <<'PB'
---
- name: Deploy /etc/motd to managed nodes
  hosts: managed
  become: true
  tasks:
    - name: Create /etc/motd
      ansible.builtin.copy:
        dest: /etc/motd
        content: "Managed by Ansible\n"
        owner: root
        group: root
        mode: '0644'
PB
```

  Run it:

```run
cd /root/rhce/deploy-file
ansible-playbook playbook.yml
```

  That first run reports changed=1 — the file went from empty to your
  content.

---

CHECK IT WORKED

  Look at what landed. It should be exactly the one line the grader checks
  for:

```run
cat /etc/motd
```

  Now prove idempotency — run it again and watch for changed=0. copy sees
  the content is already identical and does nothing:

```run
cd /root/rhce/deploy-file
ansible-playbook playbook.yml
```

---

GOTCHAS

  - The trailing newline matters. "Managed by Ansible" with no \n is a
    different file from one ending in a newline; graders (and diffs) care.
    With content:, spell the newline out as \n.
  - content: vs src:. Use content: for inline literal text; use src: to
    push an actual file from the control node. Don't mix them in one task.
  - become: true because /etc is root-owned. Forget it and you get a
    permission-denied.
  - copy is idempotent by checksum — you don't add anything special to get
    changed=0 on the second run. If yours keeps reporting changed, the
    content string probably differs (often a stray newline).
