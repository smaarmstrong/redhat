THE IDEA

  Every Linux box has a hostname — the name it calls itself. On a modern
  RHEL/Rocky system there are actually a few flavours of hostname, but the
  one that matters here is the STATIC hostname: the name written to disk in
  /etc/hostname and restored on every boot. That's the persistent identity
  of the machine.

  The tool that manages all of this is hostnamectl. It talks to systemd,
  updates /etc/hostname for you, and sets the running kernel hostname at the
  same time — one command, both jobs.

---

  Right now the machine is sitting at a neutral name (setup reset it). Let's
  look at what hostnamectl knows:

```run
hostnamectl status
```

  Note the "Static hostname" line — that's the one stored in /etc/hostname,
  and the one the grader inspects.

---

WHY IT MATTERS

  A server's name shows up in logs, in shell prompts, in TLS certificates,
  and in how other machines find it. "Set the hostname to X" is a bread-and-
  butter exam task, and the exam's golden rule applies: if the name doesn't
  survive a reboot, it scores nothing. Setting it only for the current
  session (the old `hostname foo` command) is exactly the trap.

---

HOW TO DO IT

  One command sets the static hostname and writes it to /etc/hostname
  permanently:

```run
sudo hostnamectl set-hostname server1.example.com
```

  No output means success. Behind the scenes it just wrote the single line
  server1.example.com into /etc/hostname and told the kernel the new name.

---

CHECK IT WORKED

  The grader checks two things — what hostnamectl reports as the static
  name, and the contents of /etc/hostname. Confirm both:

```run
hostnamectl --static
```

```run
cat /etc/hostname
```

  Both should read server1.example.com. That's the persistent hostname the
  grader is looking for.

---

GOTCHAS

  - Don't use the bare `hostname server1.example.com` command. It changes
    the running name only, touches nothing on disk, and is gone after a
    reboot — an instant fail.
  - Use the fully qualified name exactly as asked: server1.example.com, not
    just server1. The grader matches the whole string.
  - hostnamectl needs root, hence the sudo. Without it you'll get a
    permission error and no change.
