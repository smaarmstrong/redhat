THE IDEA

  `grep` prints the lines of a file that MATCH a pattern. The pattern can
  be plain text, but its real power is regular expressions — a compact
  language for "shapes" of text. With `-E` you get Extended Regular
  Expressions, which give you the friendly operators:

    .       any single character
    {n}     the previous item exactly n times
    (...)   a group, so a quantifier can apply to the whole group
    \.      a LITERAL dot (backslash escapes its special meaning)

  Build a pattern that describes an IPv4 address and grep hands you every
  line containing one.

---

  Here's the sample we're searching. Some lines have an IP, some don't:

```run
cat /var/log/access.sample
```

  An IPv4 address is four groups of 1-3 digits separated by dots, like
  192.168.0.10. Let's turn that description into a regex.

---

WHY IT MATTERS

  Log files are where you find out what actually happened, and they're
  huge. "Show me only the lines that mention an IP / an error / this
  user" is the daily reality of troubleshooting, and grep with a regex is
  the tool. The exam objective is literally "use grep and regular
  expressions to analyze text".

---

HOW TO DO IT

  Read the pattern piece by piece:

    [0-9]{1,3}        one to three digits (one number group, 0-255-ish)
    \.                a literal dot
    ([0-9]{1,3}\.){3} that "digits-then-dot" group, three times
    [0-9]{1,3}        the final group, with no trailing dot

  Put together: ([0-9]{1,3}\.){3}[0-9]{1,3}. Feed it to grep -E and
  send the matching lines into /root/ips.txt.

  That file sits under /root, which belongs to root, so we pipe grep's
  output to `sudo tee` to write it as root — a normal user who's been
  granted sudo, exactly the exam setup. (Reading /var/log/access.sample
  needs no sudo; it's world-readable.)

```run
grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/access.sample | sudo tee /root/ips.txt > /dev/null
```

  Single-quote the pattern so the shell doesn't try to interpret the
  parentheses or dots itself.

---

CHECK IT WORKED

  Look at what you captured:

```run
sudo cat /root/ips.txt
```

  Every line with a dotted-quad is there, in the original order; the
  lines with no address are gone. The grader runs the exact same grep and
  diffs its output against your file, so a matching pattern gives an
  identical file.

  Run the grep on its own to compare — same lines:

```run
grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/access.sample
```

  (Note: this loose pattern also matches the nonsense 999.999.999.999
  line — that's intended. Validating real 0-255 octets needs a much
  fussier regex, and the task deliberately doesn't ask for it.)

---

GOTCHAS

  - Escape the dots. A bare `.` matches ANY character, so 12X45 would
    match. `\.` means an actual dot. This is the single most common
    mistake in this pattern.
  - Use `grep -E` for {n} and (…) without backslashes. Plain grep (BRE)
    needs \{ \} and \( \) — same result, uglier. `egrep` is the old
    alias for `grep -E`.
  - Redirect matching LINES, not just the addresses. `grep -o` would
    print only the matched text; the task wants the full lines, so don't
    use -o.
  - Quote the pattern. Without quotes the shell may mangle the
    parentheses.
