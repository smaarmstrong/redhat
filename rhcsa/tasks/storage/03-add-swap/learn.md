THE IDEA

  Swap is disk space the kernel uses as overflow when RAM fills up. It
  isn't a normal filesystem you mount at a directory — it's a raw area
  formatted with a swap signature and switched on with swapon. A machine
  can have several swap areas active at once; here you're ADDING one
  alongside the system's existing swap, not replacing it.

  The lifecycle mirrors a filesystem, with swap-specific verbs:

    partition  ->  mkswap (format)  ->  swapon (activate)  ->  fstab (persist)

---

  There's a blank second disk to carve the swap partition from. Confirm
  which disk is the spare (no partitions, no mountpoint), and see the swap
  already active on the box:

```run
lsblk
```

```run
swapon --show
```

  The blank disk here is /dev/vdb. Whatever swap `swapon --show` already
  lists is the SYSTEM swap — leave it completely alone.

---

WHY IT MATTERS

  Adding swap non-destructively is a listed exam objective, and in real
  life it's how you give a memory-starved box breathing room without a
  rebuild. The golden rule applies in swap form: activating swap now with
  swapon lasts only until reboot — to make it permanent it needs a line in
  /etc/fstab, referenced by UUID with fstype swap.

---

HOW TO DO IT

  Step 1 — put a partition table on the spare and create a 256 MiB
  partition, tagged as Linux swap. We use parted non-interactively; the
  1MiB start leaves room for alignment, so 1MiB..257MiB is 256 MiB:

  Note: partitioning, formatting swap and activating it are
  privileged operations, so these commands are prefixed with
  `sudo` — a normal user who's been granted sudo, exactly the
  exam setup. (Inspecting with `lsblk` and `swapon --show` needs
  no sudo.)

```run
sudo parted -s /dev/vdb mklabel gpt
```

```run
sudo parted -s /dev/vdb mkpart primary linux-swap 1MiB 257MiB
```

---

  Tell the kernel to re-read the partition table so the new device node
  appears, then confirm it:

```run
sudo partprobe /dev/vdb; sleep 1; lsblk /dev/vdb
```

  The new partition is /dev/vdb1 (on an NVMe disk it would be nvme0n1p1 —
  the "p" naming). We'll use /dev/vdb1 from here.

---

  Step 2 — format it as swap. This writes the swap signature and a UUID:

```run
sudo mkswap /dev/vdb1
```

---

  Step 3 — activate it now, and confirm it joins the swap list:

```run
sudo swapon /dev/vdb1
```

```run
swapon --show
```

  You should now see /dev/vdb1 listed next to the original system swap.

---

  Step 4 — persist it. Grab the UUID and add an fstab line. Swap has no
  mountpoint, so the second field is the literal word "none", the fstype is
  "swap", and options are "defaults":

```run
sudo blkid -s UUID -o value /dev/vdb1
```

```run
uuid=$(sudo blkid -s UUID -o value /dev/vdb1); echo "UUID=$uuid  none  swap  defaults  0 0" | sudo tee -a /etc/fstab
```

---

  Step 5 — sanity-check the fstab line the way boot will use it. Turn all
  swap off and back on FROM fstab; if the new area comes back, the line is
  good:

```run
sudo swapoff /dev/vdb1; sudo systemctl daemon-reload; sudo swapon -a; swapon --show
```

---

CHECK IT WORKED

  The grader looks for: a ~256 MiB partition on the spare whose TYPE is
  swap, that swap active in /proc/swaps, and an fstab line for that UUID
  with fstype swap. Quick check:

```run
swapon --show; grep swap /etc/fstab
```

---

GOTCHAS

  - Never touch the existing system swap. Only swapoff/format the partition
    YOU created on the spare disk.
  - fstab fields for swap are special: mountpoint is "none" and fstype is
    "swap". A common mistake is leaving a real path there.
  - `swapon -a` reads fstab and is the real test of your line — run it
    before you finish, exactly as boot would.
  - Reference by UUID, not /dev/vdb1. Device names can shift between boots;
    the UUID is stable and is what the grader wants.
