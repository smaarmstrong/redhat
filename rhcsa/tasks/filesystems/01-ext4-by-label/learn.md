THE IDEA

  A filesystem can be pointed to in fstab three ways: by device path
  (/dev/vdb1), by UUID, or by LABEL. This task is specifically about the
  LABEL — a short human-chosen name you stamp onto the filesystem itself.
  Wherever that disk plugs in, the label travels with it, so
  "LABEL=backup" always finds the right filesystem regardless of whether
  the kernel calls it vdb1 or sdc1 today.

  ext4 is the classic Linux filesystem here, and it makes labels easy: you
  can set the label when you create it, or change it later with a separate
  tool.

    partition  ->  mkfs.ext4 -L backup  ->  mount  ->  fstab by LABEL

---

  There's a blank second disk to work on. Find the spare (no partitions, no
  mountpoint); the root disk is off-limits:

```run
lsblk
```

  The blank disk here is /dev/vdb.

---

WHY IT MATTERS

  Labels make fstab readable and portable — "LABEL=backup" says what the
  volume is far better than a random UUID or a device name that can change
  between boots. Referencing filesystems by label (and by UUID) is a listed
  objective, and the persistence rule still governs: it only counts if it
  survives a reboot, i.e. it's in /etc/fstab.

---

HOW TO DO IT

  Step 1 — put a partition table on the spare and create one partition
  spanning the disk. "100%" uses all remaining space:

  Note: partitioning, formatting and mounting are privileged
  operations, so these commands are prefixed with `sudo` — a
  normal user who's been granted sudo, exactly the exam setup.
  (Inspecting with `lsblk` needs no sudo.)

```run
sudo parted -s /dev/vdb mklabel gpt
```

```run
sudo parted -s /dev/vdb mkpart primary ext4 1MiB 100%
```

---

  Re-read the table so the partition device appears:

```run
sudo partprobe /dev/vdb; sleep 1; lsblk /dev/vdb
```

  The partition is /dev/vdb1.

---

  Step 2 — make an ext4 filesystem AND set the label "backup" in one shot.
  -L sets the label; -F forces past any old signature:

```run
sudo mkfs.ext4 -F -L backup /dev/vdb1
```

  (Already have an ext4 filesystem and just need to relabel it? That's
  `e2label /dev/vdb1 backup` — worth knowing, but here mkfs did it for us.)

---

  Confirm the label took:

```run
sudo blkid -s LABEL -o value /dev/vdb1
```

---

  Step 3 — create the mountpoint and mount it once to check:

```run
sudo mkdir -p /backup; sudo mount /dev/vdb1 /backup; findmnt /backup
```

---

  Step 4 — persist BY LABEL. The source field is the literal LABEL=backup,
  not a UUID and not /dev/vdb1:

```run
echo "LABEL=backup  /backup  ext4  defaults  0 0" | sudo tee -a /etc/fstab
```

---

  Step 5 — verify the fstab line mounts. Unmount, reload, mount from fstab:

```run
sudo umount /backup; sudo systemctl daemon-reload; sudo mount -a; findmnt /backup
```

  If /backup mounts by label, boot will too.

---

CHECK IT WORKED

  The grader checks: an ext4 partition on the spare with label "backup",
  mounted at /backup, and an fstab source that is exactly LABEL=backup.
  Quick look:

```run
sudo blkid /dev/vdb1; findmnt --fstab -o SOURCE,TARGET /backup
```

---

GOTCHAS

  - The fstab source must be LABEL=backup exactly. A UUID or /dev path
    would mount fine but fails THIS task, which is testing labels.
  - The label is case-sensitive: "backup", not "Backup".
  - Set the label at mkfs time with -L, or later with e2label. (For XFS the
    equivalents are mkfs.xfs -L and xfs_admin -L.)
  - Always `mount -a` before finishing to catch a bad fstab line while you
    can still fix it.
