THE IDEA

  Before a disk can hold filesystems it needs a partition table — the map
  at the front that says where each partition begins and ends. There are
  two table formats you must be able to tell apart:

    GPT    the modern default: many partitions, huge disks, resilient
    MBR    the older "msdos" scheme: max four primary partitions, and a
           2 TiB ceiling — but still everywhere, and what THIS task wants

  This task is deliberately about MBR (parted calls it "msdos"). Everything
  else — make a partition, put ext4 on it, mount it, persist by UUID — is
  the standard pipeline you'll use over and over.

---

  There's a blank second disk to partition. Find the spare (no partitions,
  no mountpoint) and note the root disk is off-limits:

```run
lsblk
```

  The blank disk here is /dev/vdb. We'll build the MBR table on it.

---

WHY IT MATTERS

  Recognising and creating both table types is a listed objective, and
  you'll meet MBR on older systems, USB media, and anything that must boot
  in legacy BIOS mode. The persistence rule is in force: the mount only
  counts if it's in /etc/fstab, and the task specifically wants it
  referenced BY UUID, not by /dev/vdb1.

---

HOW TO DO IT

  Step 1 — write an MBR (msdos) label. This is the one line that makes it
  MBR rather than GPT:

```run
sudo parted -s /dev/vdb mklabel msdos
```

---

  Step 2 — create one ~300 MiB primary partition. Starting at 1MiB keeps
  it aligned; 1MiB..301MiB gives 300 MiB. "ext4" here just hints the
  intended type — the real filesystem is made in the next step:

```run
sudo parted -s /dev/vdb mkpart primary ext4 1MiB 301MiB
```

---

  Re-read the table so the partition device appears, and confirm the label
  type is msdos:

```run
sudo partprobe /dev/vdb; sleep 1; lsblk /dev/vdb
```

```run
sudo parted -s /dev/vdb print | head -5
```

  The partition is /dev/vdb1. The "Partition Table: msdos" line confirms
  it's MBR.

---

  Step 3 — put an ext4 filesystem on the partition. -F forces past any old
  signature on a reused disk:

```run
sudo mkfs.ext4 -F /dev/vdb1
```

---

  Step 4 — create the mountpoint and mount it once to check:

```run
sudo mkdir -p /mnt/mbrpart; sudo mount /dev/vdb1 /mnt/mbrpart; findmnt /mnt/mbrpart
```

---

  Step 5 — persist by UUID. Read the UUID of the partition, then add the
  fstab line (source, mountpoint, fstype, options, dump, pass):

```run
sudo blkid -s UUID -o value /dev/vdb1
```

```run
uuid=$(sudo blkid -s UUID -o value /dev/vdb1); echo "UUID=$uuid  /mnt/mbrpart  ext4  defaults  0 0" | sudo tee -a /etc/fstab
```

---

  Step 6 — verify the line boots. Unmount, reload, remount from fstab:

```run
sudo umount /mnt/mbrpart; sudo systemctl daemon-reload; sudo mount -a; findmnt /mnt/mbrpart
```

---

CHECK IT WORKED

  The grader checks: the spare has an msdos (MBR) table, a ~300 MiB ext4
  partition on it, mounted at /mnt/mbrpart, with an fstab UUID line whose
  UUID matches the filesystem. A quick look:

```run
sudo parted -s /dev/vdb print | grep Table; findmnt --fstab /mnt/mbrpart
```

---

GOTCHAS

  - "msdos" IS MBR. Using mklabel gpt here would fail the "MBR table"
    check even though everything else worked.
  - After parted, run partprobe (or partx) so /dev/vdb1 exists before you
    try to mkfs it — otherwise mkfs.ext4 errors with "no such device".
  - Persist by UUID, not device path. The task's grader explicitly wants
    the source field to start UUID=.
  - Always `mount -a` before finishing. A bad fstab line is the number-one
    way to lose the mark (or brick a boot).
