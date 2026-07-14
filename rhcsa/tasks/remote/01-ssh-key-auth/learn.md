THE IDEA

  Key-based SSH replaces "type a password every time" with a pair of
  cryptographic keys. You hold a PRIVATE key (secret, stays on the client);
  the server holds the matching PUBLIC key. At login the server challenges
  you to prove you own the private key. If the maths checks out, you're in
  — no password.

  On the server side, "the server trusts this key" simply means the public
  key is a line in the target user's ~/.ssh/authorized_keys file. That's
  the whole mechanism.

---

  Right now (setup put us here) the deploy account exists and sshd is
  running, but deploy has no authorized_keys, so root can only reach it by
  password. Confirm what root has to offer:

```run
ls -l /root/.ssh/ 2>/dev/null || echo "root has no .ssh yet"
```

  Root may not even have a key pair yet — that's the first thing to fix.

---

WHY IT MATTERS

  "Configure key-based authentication for SSH" is a core RHCSA objective,
  and it's the foundation for the next skill: once keys work, you can turn
  password logins off entirely. In the real world keys are how automation,
  Ansible, and admins log in without secrets sitting in scripts.

  Our job: make ssh deploy@localhost succeed from root with NO password
  prompt, and make sure deploy's ~/.ssh and authorized_keys have the tight
  ownership and permissions sshd insists on.

---

HOW TO DO IT

  First, give root a key pair if it hasn't got one. ssh-keygen -t rsa makes
  an RSA pair; -N "" sets an empty passphrase (so no prompt at login);
  -f names the output file. Run it (harmless to run even if a key exists —
  we guard with a test):

```run
[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
```

  That writes /root/.ssh/id_rsa (private) and /root/.ssh/id_rsa.pub
  (public). We only ever hand out the .pub half.

---

  The tidy way to install it is ssh-copy-id, which appends your public key
  to the remote user's authorized_keys AND fixes permissions for you:

    ssh-copy-id deploy@localhost

  But that prompts for deploy's password interactively, which doesn't suit
  a scripted lesson — so we'll do exactly what it does, by hand. Create
  deploy's .ssh with the right mode and owner in one shot with install:

```run
install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
```

  install -d makes the directory; -m 700 sets rwx for the owner only;
  -o/-g set owner and group to deploy. sshd demands .ssh be 700 and owned
  by the user, or it silently ignores it.

---

  Now append root's PUBLIC key to deploy's authorized_keys, then lock the
  file down to 600 and owned by deploy:

```run
cat /root/.ssh/id_rsa.pub >> /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys
```

  Use >> (append), never > (overwrite) — on a real server that file may
  already hold other people's keys you must not clobber.

---

CHECK IT WORKED

  The real proof: log in as deploy with no password. BatchMode=yes tells
  ssh to fail rather than fall back to a password prompt, so if this works,
  the key really did it:

```run
ssh -o BatchMode=yes -o StrictHostKeyChecking=no deploy@localhost true
echo "exit status: $?"
```

  Exit status 0 means success. The grader checks the same login, plus every
  permission bit: .ssh is 700 and owned by deploy, authorized_keys is 600
  and owned by deploy, and it contains a valid public key (ssh-keygen -l).

---

GOTCHAS

  - Permissions are the classic trap. If .ssh isn't 700 or authorized_keys
    isn't 600 — or either is owned by root instead of deploy — sshd refuses
    them and you're back to a password prompt with no obvious error.
  - Install the PUBLIC key (.pub). Copying the private key is both wrong
    and a security blunder.
  - Append with >>. Overwriting with > can wipe existing authorized keys.
  - This persists across reboot on its own — it's just files on disk, no
    service to re-enable. sshd is already enabled from setup.
