THE IDEA

  A for loop walks through a list of words one at a time, running the same
  block for each. The shape is:

    for VAR in WORD1 WORD2 WORD3 ; do
      ...use "$VAR"...
    done

  Each pass, VAR holds the next word. The special list "$@" means "all the
  command-line arguments this script was given," so:

    for n in "$@" ; do ...

  loops once per argument. Quoted "$@" is the correct form — it keeps each
  argument as one item even if one contained a space.

---

  The other piece is arithmetic. Bash does integer maths inside $(( ... )):

    sum=$(( sum + n ))

  Everything in the double parentheses is treated as numbers, so you don't
  need $ on the variables in there. Start a running total at 0, then add
  each argument to it as you loop.

---

WHY IT MATTERS

  "Use looping constructs (for, etc.) to process file, command-line input"
  is a stated RHCSA objective. Iterating over arguments or over the lines
  of a file — restarting a list of services, chmod-ing a set of paths — is
  everyday scripting. A running accumulator inside a loop is the pattern
  you reuse constantly.

  Our job: write /usr/local/bin/sumargs.sh so it loops over all its
  arguments with a for loop, adds them as integers, and prints the total.

---

HOW TO DO IT

  Write the script with a quoted here-document so $@, $sum and $((...))
  land literally in the file rather than being expanded now:

```run
cat > /usr/local/bin/sumargs.sh <<'EOF'
#!/usr/bin/env bash
sum=0
for n in "$@"; do
  sum=$((sum + n))
done
echo "$sum"
EOF
```

  Read it top to bottom: start the total at 0; for each argument n, add it
  to sum; after the loop, print the final sum. If no arguments are given,
  the loop body never runs and it prints 0 — a sensible result.

---

  Make it executable so it can run by name:

```run
chmod +x /usr/local/bin/sumargs.sh
```

---

CHECK IT WORKED

  Run the two examples from the task:

```run
sumargs.sh 2 3 5
sumargs.sh 4
```

  You want 10 then 4. That's precisely what the grader tests — it confirms
  the file exists and is executable, then checks "2 3 5" gives 10 and "4"
  gives 4.

---

GOTCHAS

  - Quote "$@", not $@ or "$*". Bare $@ mostly works here but "$*" would
    join everything into one word — a bad habit to build.
  - Use $((...)) for the addition. sum=sum+n or sum="$sum $n" just builds
    a string; it never adds anything.
  - Print only the number. An extra label or blank line makes the compared
    output mismatch.
  - Non-integer input isn't required here, but note $((...)) errors on
    words like "abc" — the task only promises integers.
