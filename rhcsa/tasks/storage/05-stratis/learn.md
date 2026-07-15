THE IDEA

  Stratis is a newer way to manage pooled storage on RHEL. Think of it as
  "LVM + XFS wrapped in one friendly command set, managed by a daemon."
  You feed whole disks into a POOL, then carve FILESYSTEMS out of the pool.
  Filesystems grow automatically as they fill, drawing from pool space.

    disk(s)  ->  stratis pool  ->  stratis filesystem  ->  mount

  The one thing that makes Stratis different at boot: its devices only
  exist once the stratisd daemon is running. So a Stratis mount in fstab
  needs a special option telling systemd to wait for that service first.

  (This is a bonus, RHEL 8-era objective — worth knowing, and it drills the
  same pool-then-filesystem-then-persist mental model.)

---

  There's a blank second disk to build the pool on, and the setup has
  best-effort installed Stratis for you. Confirm the spare and that the
  daemon is up:

```run
lsblk
```

```run
systemctl status stratisd --no-pager | head -3
```

  The blank disk here is /dev/vdb. stratisd must be active for the stratis
  CLI to do anything.

---

WHY IT MATTERS

  Stratis gives you thin-provisioned, grow-on-demand pooled storage without
  the multi-step LVM dance. On the exam it's a bonus objective, but the
  boot-ordering lesson it teaches — a mount that depends on a service being
  up — is broadly useful (NFS, iSCSI and others have the same need).

---

HOW TO DO IT

  Step 0 — make sure the daemon is running and enabled (so it also comes
  back after reboot, which the fstab option below will rely on):

  Note: managing the stratisd service, creating pools and
  filesystems and mounting are privileged operations, so these
  commands are prefixed with `sudo` — a normal user who's been
  granted sudo, exactly the exam setup. (Inspecting with `lsblk`
  and `systemctl status` needs no sudo.)

```run
sudo systemctl enable --now stratisd
```

---

  Step 1 — create a pool named pool1 from the spare disk:

```run
sudo stratis pool create pool1 /dev/vdb
```

```run
sudo stratis pool list
```

---

  Step 2 — create a filesystem named fs1 inside pool1. Stratis formats it
  XFS and exposes it at /dev/stratis/pool1/fs1:

```run
sudo stratis filesystem create pool1 fs1
```

```run
sudo stratis filesystem list pool1
```

---

  Step 3 — make the mountpoint and mount it once to check:

```run
sudo mkdir -p /mnt/stratis; sudo mount /dev/stratis/pool1/fs1 /mnt/stratis; findmnt /mnt/stratis
```

---

  Step 4 — persist it, WITH the boot-ordering option. Because the Stratis
  device doesn't exist until stratisd starts, the fstab entry must carry:

      x-systemd.requires=stratisd.service

  That tells systemd to hold this mount until stratisd is up, so boot
  doesn't fail trying to mount a device that isn't there yet. Read the UUID
  and write the line (fstype is xfs — that's what Stratis puts down):

```run
sudo blkid -s UUID -o value /dev/stratis/pool1/fs1
```

```run
uuid=$(sudo blkid -s UUID -o value /dev/stratis/pool1/fs1); echo "UUID=$uuid  /mnt/stratis  xfs  defaults,x-systemd.requires=stratisd.service  0 0" | sudo tee -a /etc/fstab
```

  (You may reference it by device path instead of UUID — the
  x-systemd.requires option is the part that MUST be present either way.)

---

  Step 5 — verify the fstab line mounts cleanly:

```run
sudo umount /mnt/stratis; sudo systemctl daemon-reload; sudo mount -a; findmnt /mnt/stratis
```

---

CHECK IT WORKED

  The grader checks: pool1 exists, fs1 exists, /mnt/stratis is mounted from
  pool1/fs1 as XFS, and the fstab entry includes
  x-systemd.requires=stratisd.service. Quick look:

```run
sudo stratis filesystem list pool1; findmnt --fstab -o SOURCE,TARGET,OPTIONS /mnt/stratis
```

---

GOTCHAS

  - The x-systemd.requires=stratisd.service option is the whole point. Omit
    it and boot may try to mount before stratisd is up — the mount fails,
    and the grader specifically looks for that option.
  - stratisd must be running AND enabled. If the daemon is stopped, the
    stratis CLI can't talk to it and nothing works.
  - Pool first, then filesystem. `stratis filesystem create` needs an
    existing pool to live in.
  - The filesystem type in fstab is xfs — that's what Stratis lays down
    under the hood, even though you never ran mkfs yourself.
