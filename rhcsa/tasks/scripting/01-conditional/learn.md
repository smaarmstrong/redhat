THE IDEA

  A shell script is just a text file full of commands, with a "shebang"
  on the first line (#!/usr/bin/env bash) that tells the kernel which
  interpreter to feed it to. The one new idea here is branching: doing one
  thing OR another depending on a test. In bash that's the if statement:

    if SOME-COMMAND ; then
      ...runs when SOME-COMMAND succeeded (exit status 0)...
    else
      ...runs otherwise...
    fi

  Notice if doesn't test true/false the way other languages do — it runs a
  command and branches on its EXIT STATUS. Zero means success.

---

  So what command do we test? The classic one is test, which almost
  everyone writes with its alias, a pair of square brackets: [ ... ].
  These are the same program:

    test -e /etc/passwd
    [ -e /etc/passwd ]

  The -e operator means "this path exists" and exits 0 if so. Other handy
  ones: -f (a regular file), -d (a directory), -z (a string is empty).
  For this task -e is exactly right — the path could be a file OR a dir.

---

WHY IT MATTERS

  "Conditionally execute code (use of: if, test, [], etc.)" is a named
  RHCSA objective, and branching on whether a file exists is the bread and
  butter of real admin scripts: only start a service if its config is
  present, only back up a directory that actually exists, and so on.

  Our job: write /usr/local/bin/checkpath.sh so it takes one argument,
  prints EXISTS if that path exists and MISSING if it doesn't, and is
  executable. /usr/local/bin is on root's PATH, which is why scripts live
  there.

---

HOW TO DO IT

  We'll write the file with a "here-document" — cat > FILE <<'EOF' sends
  every line up to EOF into the file. Quoting the first EOF ('EOF') stops
  the shell from expanding $1 while we write, so the literal $1 lands in
  the script. Let's create it:

```run
cat > /usr/local/bin/checkpath.sh <<'EOF'
#!/usr/bin/env bash
if [ -e "$1" ]; then
  echo EXISTS
else
  echo MISSING
fi
EOF
```

  $1 is the script's first argument. Always quote it as "$1" — if someone
  passes a path with a space, an unquoted $1 would split into two words
  and break the test.

---

  A file isn't runnable just because it exists — it needs the execute bit.
  Add it with chmod +x:

```run
chmod +x /usr/local/bin/checkpath.sh
```

  Now the shebang plus the execute bit means you can run it by name.

---

CHECK IT WORKED

  Try it against a path that definitely exists, then one that can't:

```run
checkpath.sh /etc/passwd
checkpath.sh /no/such/thing
```

  You want EXISTS then MISSING. That's exactly what the grader does: it
  confirms the file exists and is executable (-x), then runs it once with a
  real temp file expecting EXISTS, and once with a bogus path expecting
  MISSING.

---

GOTCHAS

  - Forgetting chmod +x is the number-one miss. The grader checks -x
    explicitly, so no execute bit = fail even if the logic is perfect.
  - Print EXISTS/MISSING and nothing else. Stray echoes or a "Result:"
    prefix would make the compared output not match.
  - Quote "$1". Unquoted, an empty or spaced argument changes how [ ]
    parses and can throw "unary operator expected".
  - Don't hardcode a path inside the script — it must test whatever
    argument it's given, not /etc/passwd every time.
