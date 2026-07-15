THE IDEA

  VFAT (the Linux name for the FAT32 filesystem) is the lowest common
  denominator of storage — Windows, macOS, Linux, cameras, EFI firmware,
  every USB stick understands it. On RHEL it isn't part of the base install
  the way ext4 and XFS are: the mkfs.vfat tool comes from the dosfstools
  package.

  Otherwise the pipeline is exactly the one you already know:

    partition  ->  mkfs.vfat  ->  mount  ->  fstab by UUID

  The one quirk: a VFAT "UUID" isn't a long hex string, it's a short
  volume serial like 1234-ABCD. You use it in fstab exactly as blkid
  reports it.

---

  There's a blank second disk to work on, and setup best-effort installed
  dosfstools. Find the spare (no partitions, no mountpoint) and confirm the
  tool is present:

```run
lsblk
```

```run
command -v mkfs.vfat || echo "mkfs.vfat missing — dnf install dosfstools"
```

  The blank disk here is /dev/vdb.

---

WHY IT MATTERS

  You reach for VFAT any time a filesystem must be read outside Linux — a
  shared USB drive, or the EFI System Partition that every UEFI machine
  boots from is FAT. Creating and mounting VFAT is a listed objective. The
  persistence rule holds: it only counts if it's in /etc/fstab, and this
  task wants it referenced by UUID.

---

HOW TO DO IT

  Step 1 — partition the spare: a table plus one ~200 MiB partition. The
  "fat32" hint just marks the intended type; the real format comes next:

  Note: partitioning, formatting and mounting are privileged
  operations, so these commands are prefixed with `sudo` — a
  normal user who's been granted sudo, exactly the exam setup.
  (Inspecting with `lsblk` needs no sudo.)

```run
sudo parted -s /dev/vdb mklabel gpt
```

```run
sudo parted -s /dev/vdb mkpart primary fat32 1MiB 201MiB
```

---

  Re-read the table so the partition device appears:

```run
sudo partprobe /dev/vdb; sleep 1; lsblk /dev/vdb
```

  The partition is /dev/vdb1.

---

  Step 2 — make the VFAT filesystem:

```run
sudo mkfs.vfat /dev/vdb1
```

---

  Step 3 — create the mountpoint and mount it once to check:

```run
sudo mkdir -p /mnt/vfat; sudo mount /dev/vdb1 /mnt/vfat; findmnt /mnt/vfat
```

---

  Step 4 — persist by UUID. Read the (short) VFAT UUID and write the fstab
  line with fstype vfat:

```run
sudo blkid -s UUID -o value /dev/vdb1
```

  Notice how short that is — something like 1234-ABCD. Use it verbatim:

```run
uuid=$(sudo blkid -s UUID -o value /dev/vdb1); echo "UUID=$uuid  /mnt/vfat  vfat  defaults  0 0" | sudo tee -a /etc/fstab
```

---

  Step 5 — verify the fstab line mounts:

```run
sudo umount /mnt/vfat; sudo systemctl daemon-reload; sudo mount -a; findmnt /mnt/vfat
```

---

CHECK IT WORKED

  The grader checks: a ~200 MiB vfat partition on the spare, mounted at
  /mnt/vfat, with an fstab UUID line whose UUID matches the filesystem.
  Quick look:

```run
sudo blkid /dev/vdb1; findmnt --fstab -o SOURCE,TARGET,FSTYPE /mnt/vfat
```

---

GOTCHAS

  - mkfs.vfat lives in dosfstools, not the base install. If it's missing,
    `dnf install dosfstools` (setup already tried this for you).
  - The VFAT UUID is short (1234-ABCD). That's normal — don't expect the
    long hex form ext4/XFS give you, and copy it exactly.
  - fstype in fstab is "vfat" (the Linux driver name), even though the
    on-disk format is FAT32.
  - Persist by UUID as the task asks, and `mount -a` before finishing to
    catch a bad line.
