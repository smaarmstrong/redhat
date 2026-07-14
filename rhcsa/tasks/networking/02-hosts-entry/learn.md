THE IDEA

  Before a name like db.example.com can be used, the system has to turn it
  into an IP address. Usually that means asking a DNS server — but there's an
  older, simpler mechanism that runs first: a plain text file, /etc/hosts,
  that maps IP addresses to names right there on the local machine.

  Each line is dead simple:

    IP_ADDRESS   canonical-name   [alias ...]

  One IP on the left, then one or more names it answers to. No daemon, no
  network round-trip — and because it's a file on disk, it's persistent by
  nature.

---

  Take a quick look at what's in there already:

```run
cat /etc/hosts
```

  You'll typically see the loopback lines for localhost. We're going to add
  one more line of our own underneath.

---

WHY IT MATTERS

  Static /etc/hosts entries are how you pin a name to an IP without a DNS
  server — handy for hosts that don't have DNS records yet, for lab and
  cluster setups, and for overriding what DNS would say. On the exam, "make
  this name resolve to this address" is a classic, and /etc/hosts is the
  quickest correct answer.

  Under the default name-resolution order, /etc/hosts is consulted BEFORE
  DNS, so an entry here wins.

---

HOW TO DO IT

  We just need to append one line mapping the IP to the full name plus its
  short alias. Appending (>>) is important — you want to add to the file, not
  overwrite it:

```run
echo "192.168.55.10   db.example.com db" >> /etc/hosts
```

  That single line gives 192.168.55.10 two names: the canonical
  db.example.com and the short alias db. (On the exam you'd more likely open
  the file in vi and type the line — same result; the echo just keeps this
  lesson tidy.)

---

CHECK IT WORKED

  The right way to test resolution is getent, which asks the system the same
  way real programs do (honouring /etc/hosts, DNS, the lot):

```run
getent hosts db.example.com
```

```run
getent hosts db
```

  Both should print 192.168.55.10 with the name. That is exactly what the
  grader runs — it checks the full name, the short alias, AND that the line
  physically exists in /etc/hosts.

---

GOTCHAS

  - Use >> (append), not > (overwrite). A single > would wipe out the
    localhost lines and can break other things.
  - Put the IP first, then the names — the format is IP then hostnames, not
    the other way round.
  - Whitespace between fields can be spaces or tabs; either is fine. What
    matters is that db.example.com and db both sit on the same line as the
    IP.
