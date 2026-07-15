THE IDEA

  Scripts are most useful when they act on what OTHER commands say. The
  tool for that is command substitution: wrap a command in $( ... ) and
  the shell replaces it with that command's output.

    count=$(getent passwd | wc -l)

  Here getent passwd lists every account the system knows about (one per
  line), the pipe feeds that into wc -l which counts lines, and $( ... )
  captures the resulting number into the variable count. Now you can echo
  it, test it, do maths on it — whatever you like.

---

  Why getent passwd rather than reading /etc/passwd directly? getent asks
  the full name-service stack, so it also sees accounts that live outside
  the flat file (LDAP, SSSD, and so on). On a plain box the count matches
  wc -l /etc/passwd, but getent is the more correct habit — and it's what
  the grader uses to work out the expected number.

---

WHY IT MATTERS

  "Process output of shell commands within a script" is a named RHCSA
  objective. Capturing a command's output into a variable is the glue of
  shell scripting: count something, grab a UUID, read today's date, then
  branch or report on it.

  Our job: write /usr/local/bin/countusers.sh so that, when run, it prints
  ONLY the number of user accounts — the line count of getent passwd — and
  nothing else.

---

HOW TO DO IT

  Write the script with a quoted here-document so the $( ) is stored
  literally and evaluated each time the script RUNS, not once now:

  Note: /usr/local/bin is owned by root and you're a normal user,
  so the commands that create the script there are prefixed with
  `sudo` — a normal user who's been granted sudo, exactly the exam
  setup. (Running the finished script needs no sudo, since it only
  prints.)

```run
sudo tee /usr/local/bin/countusers.sh > /dev/null <<'EOF'
#!/usr/bin/env bash
count=$(getent passwd | wc -l)
echo "$count"
EOF
```

  Doing the capture inside the script matters: the task wants the script
  itself to run the command and report the live number, so it stays correct
  even if accounts are added or removed later.

---

  Make it executable:

```run
sudo chmod +x /usr/local/bin/countusers.sh
```

---

CHECK IT WORKED

  Run the script, then compute the same number by hand and compare:

```run
countusers.sh
getent passwd | wc -l
```

  The two numbers must match. The grader does exactly this: it computes
  getent passwd | wc -l as the expected value, then checks the script's
  output (with whitespace stripped) equals it — and that the file is
  executable.

---

GOTCHAS

  - Print ONLY the number. A greeting, a label, or "Users: 42" makes the
    output not equal the bare count. echo "$count" alone is right.
  - Capture with $( ), not backticks-of-habit gone wrong. Backticks work
    but nest badly; $( ) is the modern, readable form.
  - Don't precompute the number and hardcode it — the script must run the
    command itself, or it'll be wrong the moment an account changes.
  - Remember chmod +x; the grader checks the execute bit.
