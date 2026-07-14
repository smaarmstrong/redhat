THE IDEA

  LVM (Logical Volume Manager) sits between your raw disks and your
  filesystems and gives you a flexible middle layer. There are three
  building blocks, and they stack:

    physical volume (PV)   a whole disk or partition, initialised for LVM
    volume group   (VG)    a pool made of one or more PVs
    logical volume (LV)    a slice carved out of that pool — this is what
                           you put a filesystem on and mount

  So the pipeline is always: PV -> VG -> LV -> filesystem -> mount. Once
  you internalise that order, every LVM task is just the same five moves.

---

  This task has a blank second disk for you to build on. Let's confirm
  which one it is — the spare shows no partitions and no mountpoint (the
  root disk is the one carrying / and its partitions):

```run
lsblk
```

  On this machine the blank disk is /dev/vdb. We'll use that throughout;
  the root disk is off-limits.

---

WHY IT MATTERS

  LVM is why you can grow /var next month without repartitioning or
  reinstalling. Instead of a filesystem being nailed to a fixed partition,
  it lives on an LV you can extend from spare pool space at will. The exam
  leans on LVM heavily, and the golden rule rides along: a mount only
  counts if it comes back after a reboot — which means an /etc/fstab entry,
  by UUID or label, not just a live `mount` command.

---

HOW TO DO IT

  Step 1 — make the disk a physical volume. This writes an LVM header so
  LVM will accept it into a pool:

```run
sudo pvcreate -y /dev/vdb
```

---

  Step 2 — create a volume group named vg_data on top of that PV. The VG
  is the pool we'll carve from:

```run
sudo vgcreate vg_data /dev/vdb
```

---

  Step 3 — carve a logical volume named lv_files, 512 MiB, out of the
  pool. -L sets the size, -n sets the name:

```run
sudo lvcreate -y -L 512M -n lv_files vg_data
```

  The new device appears at /dev/vg_data/lv_files (LVM also makes a
  matching path under /dev/mapper/). That's what we format next.

---

  Step 4 — put an XFS filesystem on the LV. XFS is the RHEL 9 default:

```run
sudo mkfs.xfs -f /dev/vg_data/lv_files
```

---

  Step 5 — make the mountpoint and mount it once to check it works:

```run
sudo mkdir -p /data
sudo mount /dev/vg_data/lv_files /data
```

```run
findmnt /data
```

---

  Step 6 — persistence. A live mount evaporates on reboot; the exam wants
  it in /etc/fstab, and referenced BY UUID (a stable identity that follows
  the filesystem even if device names shuffle). First read the UUID:

```run
sudo blkid -s UUID -o value /dev/vg_data/lv_files
```

---

  Now append an fstab line using that UUID. This one-liner grabs the UUID
  and writes the entry safely — fields are: source, mountpoint, fstype,
  options, dump, and fsck-pass:

```run
uuid=$(sudo blkid -s UUID -o value /dev/vg_data/lv_files); echo "UUID=$uuid  /data  xfs  defaults  0 0" | sudo tee -a /etc/fstab
```

  (On the exam you would just open /etc/fstab in vi and type the line —
  `UUID=<the-uuid>  /data  xfs  defaults  0 0`. Same result.)

---

  Step 7 — prove the fstab line is valid by unmounting and remounting via
  fstab. If `mount -a` errors, fix the line NOW, not at reboot:

```run
sudo umount /data
sudo systemctl daemon-reload
sudo mount -a
```

```run
findmnt /data
```

---

CHECK IT WORKED

  The grader checks the whole stack: vg_data and lv_files exist, the LV is
  ~512 MiB, it carries XFS, it's mounted at /data, and fstab references it
  by UUID with a UUID that matches the live filesystem. A quick self-check:

```run
sudo lvs vg_data; findmnt --fstab /data
```

---

GOTCHAS

  - Order matters: pvcreate, then vgcreate, then lvcreate. Skip a layer
    and the next command has nothing to build on.
  - Persist by UUID, not device path. /dev/vg_data/lv_files happens to be
    stable, but the task explicitly wants UUID= in fstab, and that's the
    habit the exam rewards.
  - Always run `mount -a` before you walk away. A typo in fstab that you
    don't catch becomes an unbootable machine (or a failed grade).
  - `mkfs.xfs` needs -f to overwrite any old signature on a reused disk.
