THE IDEA

  autofs mounts filesystems ON DEMAND. Instead of a permanent fstab entry
  that mounts a share at boot and holds it forever, autofs waits: the
  moment someone touches a configured path, it mounts the filesystem, and
  after a period of inactivity it quietly unmounts it again.

  That's perfect for network shares that may not always be reachable — no
  boot hang if the server is down, no idle mounts sitting around. The
  trade-off is that the path does NOT appear in `mount` or findmnt until
  you actually access it.

  autofs configuration has two layers:

    the MASTER map    says "this directory is managed by autofs, using
                      that map file" — e.g.  /mnt/auto  ->  /etc/auto.share
    a MAP file        says how each key under it mounts — e.g. the key
                      "share" mounts localhost:/srv/share over NFS

  Access /mnt/auto/share and autofs reads the map, sees the "share" key,
  and mounts it. This is called an INDIRECT map (keys are subdirectories
  under a managed root).

---

  This machine already exports /srv/share over NFS to itself, and setup
  best-effort installed autofs. Confirm the export and that autofs is
  present but not yet configured:

```run
showmount -e localhost
```

```run
rpm -q autofs; systemctl is-active autofs || true
```

  This task does NOT use the spare disk — it's all config files and a
  service.

---

WHY IT MATTERS

  autofs is how big environments mount home directories and shared trees
  without pinning every one at boot: they appear when needed and vanish
  when idle. Configuring autofs is a listed objective. Persistence here
  means two things: the config lives on disk AND the autofs service is
  ENABLED so it starts at boot.

---

HOW TO DO IT

  Step 1 — declare the managed root via a master-map drop-in. Rather than
  editing the packaged /etc/auto.master, RHEL lets you drop a file into
  /etc/auto.master.d/ (it must end in .autofs). This line says "/mnt/auto
  is managed, look up keys in /etc/auto.share":

```run
sudo mkdir -p /etc/auto.master.d
```

```run
printf '/mnt/auto\t/etc/auto.share\n' | sudo tee /etc/auto.master.d/share.autofs
```

---

  Step 2 — write the map file it points at. The format is:

      key   -options   source

  So the key "share" (which becomes the subdirectory /mnt/auto/share) is an
  NFS mount of localhost:/srv/share:

```run
printf 'share\t-fstype=nfs\tlocalhost:/srv/share\n' | sudo tee /etc/auto.share
```

---

  Step 3 — enable and start autofs so it reads the maps now AND at boot:

```run
sudo systemctl enable --now autofs
```

  If you edit maps while it's already running, reload it to pick up
  changes:

```run
sudo systemctl reload autofs 2>/dev/null || sudo systemctl restart autofs
```

---

  Step 4 — trigger the mount by simply ACCESSING the path. autofs creates
  /mnt/auto/share on the fly and mounts the share when you touch it:

```run
ls /mnt/auto/share
```

  You should see the README the server put there. Now check it's a real
  NFS mount:

```run
findmnt /mnt/auto/share
```

  Note: before that `ls`, /mnt/auto/share does not show up in findmnt at
  all — that on-access behaviour is the whole point of autofs.

---

CHECK IT WORKED

  The grader checks: autofs is installed, enabled, and running; a master
  map references /mnt/auto; a map entry points at localhost:/srv/share; and
  accessing /mnt/auto/share triggers an NFS mount. Quick look:

```run
systemctl is-enabled autofs; systemctl is-active autofs; ls /mnt/auto/share; findmnt /mnt/auto/share
```

---

GOTCHAS

  - Two layers: the master map (or drop-in) AND the map file it points to.
    Get one without the other and nothing mounts.
  - Drop-in files in /etc/auto.master.d/ must end in .autofs, or autofs
    ignores them.
  - Don't pre-create /mnt/auto/share yourself and don't add it to
    /etc/fstab — autofs manages that directory. A stray manual mount or
    directory can get in its way.
  - "Enabled" matters as much as "running": `systemctl enable --now`
    covers both, so it survives a reboot.
  - The path won't appear in `mount`/findmnt until you access it once —
    that's expected, not a failure.
