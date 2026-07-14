THE IDEA

  Onboarding a user end to end is the classic composite user-management
  task: identity, privilege, policy, access, and workspace, each a small
  standard job. As with any multi-part scenario, the real skill is reading
  the brief and turning it into an ordered checklist:

    1. group engineering (GID 5000) + user nadia (groups, GECOS, shell)
    2. full sudo for nadia via a VALIDATED /etc/sudoers.d drop-in
    3. password aging: max 90, min 1, warn 14
    4. key-based SSH so root -> nadia@localhost needs no password
    5. project dir /home/nadia/reports, nadia:engineering, mode 2770

  There's a natural order: nadia has to exist before you can give her sudo,
  set her aging, drop a key in her home, or make her a directory. So the
  account comes first; the rest hang off it.

---

WHY IT MATTERS

  Provisioning accounts correctly — right groups, sane password policy,
  key-based login, least surprise on permissions — is bread-and-butter
  sysadmin work and a heavily weighted exam area. And the golden rule
  still rides along: these settings live in /etc/passwd, /etc/group,
  /etc/shadow, /etc/sudoers.d and the user's home, so they're already
  persistent by nature — but a wrong field (say sudo that doesn't validate)
  fails just as hard as a change that doesn't survive reboot.

---

HOW TO DO IT

  Part 1 — group then user, in one pass. Create engineering with a FIXED
  GID of 5000 first, then create nadia. useradd flags: -m makes her home,
  -c sets the GECOS comment, -s sets the login shell, and -G adds her to
  the SUPPLEMENTARY group engineering (her primary group stays her own
  user-private group):

```run
sudo groupadd -g 5000 engineering
sudo useradd -m -c "Nadia Ops" -s /bin/bash -G engineering nadia
```

  Note the exact GECOS string "Nadia Ops" — the grader compares it
  literally, so capitalisation and the single space matter.

---

  Part 2 — full sudo via a drop-in that VALIDATES. Never edit /etc/sudoers
  directly on the exam; drop a file in /etc/sudoers.d instead. The rule
  `nadia ALL=(ALL) ALL` means: on ALL hosts, as ANY user, run ANY command.
  Set mode 0440 (sudoers files must not be group/other writable) and then
  confirm it parses with visudo -cf — a syntax error in a sudoers file can
  lock everyone out of sudo:

```run
echo 'nadia ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/nadia
sudo chmod 0440 /etc/sudoers.d/nadia
sudo visudo -cf /etc/sudoers.d/nadia
```

  You want to see "parsed OK". The grader re-runs visudo -cf itself, so
  this is exactly the check it applies.

---

  Part 3 — password aging. One command sets all three fields in
  /etc/shadow: -M maximum days, -m minimum days, -W warning days:

```run
sudo chage -M 90 -m 1 -W 14 nadia
```

  Confirm the fields landed the way the grader reads them:

```run
sudo chage -l nadia
```

---

  Part 4 — key-based SSH, root -> nadia@localhost with no password. Four
  moves: make sure root HAS a keypair; create nadia's ~/.ssh at mode 700
  owned by her; append root's PUBLIC key to her authorized_keys at mode
  600 owned by her; and make sure sshd is up. First, the keypair (only
  generate if one isn't already there):

```run
[ -f /root/.ssh/id_rsa ] || sudo ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
```

---

  Now build nadia's .ssh with the right ownership and modes, and install
  root's public key. `install -d` creates the directory with owner, group,
  and mode in one shot — sshd REFUSES a key if ~/.ssh or authorized_keys is
  too permissive, so 700 and 600 are not optional:

```run
sudo install -d -m 700 -o nadia -g nadia /home/nadia/.ssh
sudo cp /root/.ssh/id_rsa.pub /home/nadia/.ssh/authorized_keys
sudo chmod 600 /home/nadia/.ssh/authorized_keys
sudo chown nadia:nadia /home/nadia/.ssh/authorized_keys
sudo systemctl enable --now sshd
```

---

  Prove it works the way the grader will — a non-interactive login. If key
  auth is right this returns immediately with no password prompt;
  BatchMode=yes makes it FAIL rather than fall back to asking:

```run
sudo ssh -o BatchMode=yes -o StrictHostKeyChecking=no nadia@localhost true && echo "passwordless login OK"
```

---

  Part 5 — the collaborative project directory. Owner nadia, group
  engineering, mode 2770. The leading 2 is setgid, so files created inside
  inherit the engineering group; 770 gives owner and group full access and
  others NOTHING:

```run
sudo mkdir -p /home/nadia/reports
sudo chown nadia:engineering /home/nadia/reports
sudo chmod 2770 /home/nadia/reports
```

---

CHECK IT WORKED

  The grader checks all five parts: engineering exists with GID 5000; nadia
  exists, is in engineering, GECOS is "Nadia Ops", shell is /bin/bash; a
  validated sudoers.d rule grants her full sudo; shadow shows max 90 / min
  1 / warn 14; ~/.ssh is 700 and authorized_keys is 600, both nadia-owned,
  holding a valid key, and root can ssh in passwordlessly; and reports is
  nadia:engineering at 2770. A fast sweep:

```run
id nadia; sudo chage -l nadia | head -4; stat -c '%U %G %a' /home/nadia/.ssh /home/nadia/.ssh/authorized_keys /home/nadia/reports
```

---

GOTCHAS

  - GECOS is compared literally — "Nadia Ops", exact case and spacing.
  - Always validate sudoers with visudo -cf. An unparseable file is worse
    than useless, and the grader rejects it.
  - SSH is strict about permissions: ~/.ssh must be 700, authorized_keys
    600, both owned by the user. Loose modes = silent auth failure.
  - -G adds SUPPLEMENTARY groups. Using -g would change her PRIMARY group
    instead — not what's asked. And -aG matters only with usermod (to
    avoid clobbering existing groups); on useradd, -G is fine as-is.
  - The leading 2 in 2770 is setgid, not sticky (1) or setuid (4).
