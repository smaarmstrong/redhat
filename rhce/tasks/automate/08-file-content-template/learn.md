THE IDEA

  Sometimes you don't edit a file, you write it whole from content you define
  in the playbook. The copy module can do that without any source file — its
  `content:` option takes a string (or a variable) and writes it straight to
  the destination:

    ansible.builtin.copy   with content: instead of src:

  Combine that with a variable and you get a clean pattern: define the text
  once in vars:, reference it with {{ }}, and copy renders it into place. This
  task writes a two-line /etc/motd from a variable called motd_text.

  setup.sh blanked out /etc/motd. Working directory: /opt/rhce/motd-content/.

---

  Look at the current (empty) motd:

```run
cat /etc/motd; echo "---end---"
```

  Nothing between the command and ---end---: the file is empty. The playbook
  will fill it with exactly two lines.

---

WHY IT MATTERS

  Rendering managed content into a file from a variable is the gateway to
  templating on the exam. Here it's a literal string; swap copy for the
  template module and content for a Jinja2 .j2 file and you have host-specific
  configs. Learning the variable-to-file flow now — vars:, {{ }},
  content: — is the foundation. The grader checks the file's two lines
  exactly.

---

HOW TO DO IT

  Write the playbook. The play-level vars: block defines motd_text as a
  two-line literal (the | keeps the newlines); the copy task feeds it in via
  content:

```run
cd /opt/rhce/motd-content
cat > playbook.yml <<'EOF'
---
- name: Manage /etc/motd from a content variable
  hosts: managed
  become: true
  vars:
    motd_text: |
      Authorized access only.
      Managed by Ansible.
  tasks:
    - name: Write the message of the day
      ansible.builtin.copy:
        content: "{{ motd_text }}"
        dest: /etc/motd
        owner: root
        group: root
        mode: '0644'
EOF
```

  content: "{{ motd_text }}" substitutes the variable's value as the file's
  contents. dest is the target path; owner/group/mode set ownership and
  permissions. Because copy compares content, a second run with the same text
  changes nothing.

---

  Run it:

```run
cd /opt/rhce/motd-content && ansible-playbook playbook.yml
```

  changed=1. Now re-run for idempotence:

```run
cd /opt/rhce/motd-content && ansible-playbook playbook.yml
```

  changed=0 — the file's content already matches motd_text, so copy leaves it
  alone.

---

CHECK IT WORKED

  The grader checks line 1, line 2, and that there are exactly two content
  lines. Confirm:

```run
cat /etc/motd
```

  You want exactly:
    Authorized access only.
    Managed by Ansible.
  and nothing else.

---

GOTCHAS

  - The | literal block scalar preserves the two lines and adds a single
    trailing newline — right for a text file. A plain quoted string with \n
    would be trickier to get exactly right.
  - Use content: (inline text), not src: (which expects a file on the control
    node). Mixing them up is a classic copy-module error.
  - Match the required lines exactly — same words, same order, same
    capitalisation and full stops. The grader compares each line literally.
  - This is the copy module; when a task says "template" and gives you a .j2
    file, reach for ansible.builtin.template instead — same idea, Jinja2
    rendered.
