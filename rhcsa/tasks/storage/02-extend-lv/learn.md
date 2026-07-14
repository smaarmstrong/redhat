THE IDEA

  The whole point of LVM is that a logical volume isn't stuck at the size
  you first gave it. If the volume group still has free space, you can make
  an LV bigger — and, crucially, grow the filesystem on top of it — while
  it stays mounted and in use. No downtime, no unmount.

  There are always TWO layers to grow, in order:

    1. the logical volume (the container)     -> lvextend
    2. the filesystem inside it (the content)  -> xfs_growfs

  Grow only the LV and `df` still shows the old size — the filesystem has
  no idea the container got bigger until you tell it.

---

  This machine already has the starting state built for you: a volume group
  vg_app with a 256 MiB XFS logical volume lv_app, mounted at /app and
  already listed in /etc/fstab by UUID. Have a look:

```run
lvs vg_app; df -h /app
```

  df should report roughly 256 MiB. Our job: take it to 512 MiB without
  ever unmounting /app.

---

WHY IT MATTERS

  "The /app volume is full, add space now, users are on it" is the single
  most common storage task in real life and a staple of the exam. Doing it
  live — no unmount — is the skill being tested. And note the persistence
  angle is already handled: extending an LV keeps the SAME filesystem UUID,
  so the existing fstab line stays correct. You do NOT touch fstab here.

---

  Before you resize, check the pool actually has room to give. Look at the
  VFree column:

```run
sudo vgs vg_app
```

  There should be well over 256 MiB free (the spare disk backs this VG), so
  the extend will succeed.

---

HOW TO DO IT

  Step 1 — extend the logical volume to 512 MiB. -L 512M sets an absolute
  target size (you could instead say -L +256M to ADD 256 MiB — either
  reaches 512):

```run
sudo lvextend -L 512M /dev/vg_app/lv_app
```

  The LV is now 512 MiB, but the XFS filesystem inside is still 256 MiB.

---

  Step 2 — grow the filesystem to fill the enlarged LV. XFS grows online
  and is told by MOUNTPOINT, not device:

```run
sudo xfs_growfs /app
```

  Key XFS fact: XFS can only ever GROW, and only while MOUNTED. That's the
  opposite of the tool you'd reach for on ext4 (resize2fs), and it's a
  favourite exam trap.

---

  Shortcut worth knowing: lvextend can do both steps at once with -r
  (resize), which calls the right growfs tool for the filesystem type:

    $ sudo lvextend -r -L 512M /dev/vg_app/lv_app

  Either approach passes. The two-step version above makes the layering
  obvious, which is why it's the one to learn first.

---

CHECK IT WORKED

  Confirm both layers grew — the LV size AND what df now reports for /app:

```run
sudo lvs vg_app/lv_app; df -h /app
```

  df should now show close to 512 MiB, and /app never left the mount table.
  The grader checks: lv_app is ~512 MiB, /app is still mounted as XFS, df
  shows well over 400 MiB, and fstab still references it by UUID.

---

GOTCHAS

  - Two layers, in order: lvextend THEN xfs_growfs. Forgetting the growfs
    is the classic half-done extend — the disk got bigger, the filesystem
    didn't.
  - XFS grows only, and only while mounted. Don't unmount /app "to be
    safe" — xfs_growfs needs it mounted, and the task forbids unmounting.
  - No fstab edit needed. The UUID is unchanged by a resize, so the
    existing entry stays valid. Editing it here just risks breaking it.
  - Make sure the VG has free space first (vgs). If VFree is too small
    you'd have to add another PV to the group before extending.
