THE IDEA

  The SSH server reads its settings from /etc/ssh/sshd_config PLUS every
  file in /etc/ssh/sshd_config.d/. The single knob that controls whether
  people can log in with a password is:

    PasswordAuthentication no

  Turn it off and only key-based logins work — which is exactly why you set
  up keys first. This is server-side hardening: it doesn't touch how YOU
  authenticate, it changes what the daemon will accept from anyone.

---

  One wrinkle on RHEL/Rocky 9: config is assembled from several files, and
  when the same setting appears more than once, the FIRST match wins in the
  main file, but drop-ins are pulled in early via an Include near the top.
  Rocky ships /etc/ssh/sshd_config.d/50-redhat.conf. Setup here has forced
  PasswordAuthentication yes on, so we must make our "no" the one that
  takes effect. See the current effective value:

  Note: sshd's config and host keys under /etc/ssh are readable
  only by root, so `sshd -T`, `sshd -t`, the drop-in write, and the
  reload are all prefixed with `sudo` — a normal user who's been
  granted sudo, exactly the exam setup.

```run
sudo sshd -T | grep -i passwordauthentication
```

  sshd -T prints the fully merged, effective configuration — the source of
  truth. Right now it says yes.

---

WHY IT MATTERS

  This maps to the RHCSA objective around SSH key authentication — the
  point of keys is to be able to switch passwords off. On a real internet-
  facing host, PasswordAuthentication no is one of the highest-value
  hardening steps you can take: it kills password brute-forcing dead.

  Our job: make the effective setting PasswordAuthentication no, keep the
  config valid (sshd -t), reload sshd, and have it survive a reboot.

---

HOW TO DO IT

  The clean, upgrade-safe approach is a drop-in file rather than editing
  the shipped config. Because the Include for sshd_config.d sits at the TOP
  of the main file, our drop-in's "no" is read before the "yes" that setup
  left further down in sshd_config — and with first-match-wins, no wins.
  (50-redhat.conf doesn't set this key, so it doesn't interfere.) Create it:

```run
sudo tee /etc/ssh/sshd_config.d/99-no-password.conf > /dev/null <<'EOF'
PasswordAuthentication no
EOF
```

  Drop-ins are preferred because a package update can overwrite the main
  sshd_config but won't touch your own file.

---

  Never reload a config you haven't validated — a syntax error can leave
  sshd unable to start, and if you're remote that locks you out. Check it,
  then reload so the running daemon picks it up:

```run
sudo sshd -t && sudo systemctl reload sshd
```

  sshd -t parses the config and stays silent if it's good; the && means
  reload only happens if the test passed. reload re-reads config without
  dropping existing connections.

---

CHECK IT WORKED

  Ask sshd for the effective value again — it should now say no:

```run
sudo sshd -T | grep -i passwordauthentication
```

  That's the grader's primary check: it reads PasswordAuthentication from
  sshd -T and requires no. It also confirms sshd -t passes, that a "no"
  is actually written in a config file (so it persists a reboot), and that
  the sshd service is active.

---

GOTCHAS

  - "Last/effective wins," not "I wrote it somewhere." If a lingering
    PasswordAuthentication yes overrides yours, the effective value is
    still yes. Trust sshd -T, not grep of a single file.
  - Always run sshd -t before reloading. A typo in the config can stop
    sshd from restarting — a real lockout risk on a remote box.
  - Reload (or restart) is required for the LIVE change, but the file is
    what survives a reboot. The grader wants both: file present AND daemon
    active.
  - Make sure key auth already works before you kill passwords, or you can
    lock yourself out entirely.
