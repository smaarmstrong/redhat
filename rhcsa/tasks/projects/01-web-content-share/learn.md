THE IDEA

  This is a composite task: one sentence in the brief, but really six
  smaller jobs stacked into a single deliverable. The skill being tested
  isn't any one command — it's DECOMPOSING a real-world request into an
  ordered checklist and doing each part so it survives a reboot.

  Read the brief and pull out the parts. Here they are, in the order they
  naturally build on each other:

    1. carve storage: PV -> VG (vg_web) -> LV (lv_web, 1 GiB)
    2. make a filesystem and mount it at /srv/www, persistently, by UUID
    3. create the webdev group
    4. make /srv/www a setgid collaborative dir owned by webdev (2775)
    5. label /srv/www for Apache in SELinux, persistently
    6. open http in the firewall, permanently

  Do them in that order and each step has what it needs from the one
  before: you can't chgrp a mountpoint that isn't mounted, and you can't
  restorecon a directory that doesn't exist yet.

---

  First, get the lay of the land. Confirm which disk is the spare (blank,
  no partitions, no mountpoint — the root disk is the one carrying /):

```run
lsblk
```

  On this machine the spare is /dev/vdb. We'll build on that throughout;
  the root disk is off-limits.

---

WHY IT MATTERS

  Every RHCSA scenario is graded on the END STATE and on persistence, not
  on the fact that it works right now. A composite task multiplies that
  rule by six: any single part that doesn't come back after reboot loses
  its points. So the working method is: do a part, then immediately prove
  it persists (fstab line, permanent firewall rule, semanage rule), then
  move on. Never leave a "runtime only" change and hope.

---

HOW TO DO IT

  Part 1 — the LVM stack. The pipeline is always PV -> VG -> LV. Mark the
  spare as a physical volume, pool it into vg_web, then carve a 1 GiB
  logical volume named lv_web:

```run
sudo pvcreate -y /dev/vdb
sudo vgcreate vg_web /dev/vdb
sudo lvcreate -y -L 1G -n lv_web vg_web
```

  The new device appears at /dev/vg_web/lv_web. That's what we format next.

---

  Part 2 — filesystem, mountpoint, and a PERSISTENT mount by UUID. Put XFS
  (the RHEL 9 default) on the LV and create the mountpoint:

```run
sudo mkfs.xfs -f /dev/vg_web/lv_web
sudo mkdir -p /srv/www
```

---

  Now persist it. A live `mount` evaporates on reboot; the exam wants an
  /etc/fstab line, and referenced BY UUID (stable identity), not by device
  path. Grab the UUID and append the entry — fields are source, mountpoint,
  fstype, options, dump, fsck-pass:

```run
uuid=$(sudo blkid -s UUID -o value /dev/vg_web/lv_web); echo "UUID=$uuid  /srv/www  xfs  defaults  0 0" | sudo tee -a /etc/fstab
```

  (On the exam you'd just open /etc/fstab in vi and type the same line.)

---

  Prove the fstab line actually works BEFORE trusting it: reload systemd's
  view of fstab and mount everything. If `mount -a` errors, fix the line
  now — a bad fstab line can leave the machine unbootable:

```run
sudo systemctl daemon-reload
sudo mount -a
findmnt /srv/www
```

---

  Parts 3 + 4 — the collaborative setgid directory. Create the webdev
  group, hand /srv/www to it, and set mode 2775. The leading 2 is the
  SETGID bit: new files created inside inherit the webdev group instead of
  the creator's own group — that's what makes it collaborative. 775 gives
  owner and group full access, others read/execute but NOT write:

```run
sudo groupadd -f webdev
sudo chgrp webdev /srv/www
sudo chmod 2775 /srv/www
```

---

  Part 5 — SELinux labelling, persistently. Apache is only allowed to
  serve files whose SELinux type is httpd_sys_content_t. Two moves here,
  and both matter: `semanage fcontext -a` writes a PERSISTENT rule into
  policy (so the label survives a relabel/reboot), then `restorecon`
  APPLIES that rule to the files on disk right now:

```run
sudo semanage fcontext -a -t httpd_sys_content_t '/srv/www(/.*)?'
sudo restorecon -Rv /srv/www
```

  The (/.*)? suffix means "this directory AND everything under it". If you
  only ran `chcon`, the label would be correct now but a restorecon or
  reboot would wipe it — the grader specifically checks for the persistent
  rule.

---

  Part 6 — the firewall. Open the http service PERMANENTLY, then reload so
  it's active in the running firewall too. Permanent config is what
  survives reboot; the reload folds it into the live ruleset:

```run
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

---

CHECK IT WORKED

  The grader walks the same six parts: vg_web/lv_web exist and lv_web is
  ~1 GiB; /srv/www carries XFS, is mounted, and fstab references it by a
  UUID matching the live filesystem; webdev exists and owns /srv/www at
  mode 2775; the runtime type is httpd_sys_content_t AND a persistent
  semanage rule maps it; firewalld allows http in both permanent and
  runtime config. A quick self-check hitting each area:

```run
sudo lvs vg_web; findmnt --fstab /srv/www; stat -c '%G %a' /srv/www; ls -Zd /srv/www; sudo firewall-cmd --query-service=http
```

---

GOTCHAS

  - Persist EVERY part. fstab by UUID, semanage (not chcon), firewalld
    --permanent. Any runtime-only change is a silent fail on reboot.
  - Order dependencies: mount before you chgrp/chmod the mountpoint;
    create the dir before restorecon. Skip ahead and the step no-ops.
  - The setgid bit is the leading 2 in 2775 — don't drop it to plain 775,
    and don't confuse it with the sticky bit (1) or setuid (4).
  - restorecon APPLIES the rule; semanage RECORDS it. You need both. A
    semanage rule with no restorecon leaves the files still mislabelled.
  - Run `mount -a` before walking away — catch a bad fstab line now.
