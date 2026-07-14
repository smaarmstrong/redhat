THE IDEA

  Not everything deserves a playbook. When you just want to DO one thing
  right now — check who's up, restart a service, gather a fact — you reach
  for an ad-hoc command. That's the `ansible` command (not
  ansible-playbook), and its shape is:

    ansible <pattern> -m <module> [-a "args"]

  `<pattern>` picks hosts from your inventory (a group name, a host, or
  `all`); `-m` names a module; `-a` passes its arguments. One line, run
  against your whole fleet.

  The simplest health check is the ping module:

    ansible managed -m ping

  This is NOT an ICMP ping. It's an Ansible module that connects over SSH,
  checks Python is usable on the far end, and replies "pong". If it comes
  back green, that node is genuinely ready for Ansible to manage.

---

  Your working directory is /root/rhce/adhoc-script; the `managed` group
  in the inventory is localhost. Try the ad-hoc ping by hand first:

```run
cd /root/rhce/adhoc-script
ansible managed -m ping
```

  You should see localhost | SUCCESS with "ping": "pong".

---

WHY IT MATTERS

  "Validate a working configuration using ad hoc commands" is its own
  objective. Ad-hoc ping is how you confirm connectivity, key-based login,
  and Python are all in place BEFORE you trust a playbook to run. And the
  command's exit status is meaningful — 0 if every host answered, non-zero
  if any failed — which makes it perfect to wrap in a health-check script.

---

HOW TO DO IT

  The task wants that ad-hoc command captured in an executable script,
  check.sh, that exits non-zero when the ping fails. Two details make the
  script robust:

    - `cd "$(dirname "$0")"` so it finds this directory's ansible.cfg and
      inventory no matter where it's called from.
    - the script's exit status is just ansible's exit status (the last
      command), so a failed ping naturally makes the script fail too.

  Write it with a heredoc:

```run
cd /root/rhce/adhoc-script
cat > check.sh <<'SH'
#!/usr/bin/env bash
# Validate the managed nodes with an ad-hoc ping. Exits non-zero on failure.
cd "$(dirname "$0")" || exit 1
ansible managed -m ping
SH
```

  A script isn't runnable until it's executable, so set the bit:

```run
cd /root/rhce/adhoc-script
chmod +x check.sh
```

---

CHECK IT WORKED

  Run the script the way the grader does, then inspect its exit code —
  0 means every managed host answered:

```run
cd /root/rhce/adhoc-script
./check.sh
echo "exit code: $?"
```

  Confirm the executable bit is set (the x's in the listing):

```run
ls -l /root/rhce/adhoc-script/check.sh
```

---

GOTCHAS

  - ansible vs ansible-playbook. Ad-hoc uses the plain `ansible` binary
    with -m; ansible-playbook is only for YAML playbook files.
  - Don't forget chmod +x. A script with the right contents but no execute
    bit fails "is executable" and can't be run as ./check.sh.
  - The module ping is not networking ping. It's an Ansible connectivity
    check that also verifies Python on the target — a passing pong means
    much more than an ICMP echo would.
  - Let the exit status flow through. Because ansible's exit code is the
    script's last command, you get the non-zero-on-failure behaviour for
    free — don't accidentally swallow it with `|| true` or an echo after.
