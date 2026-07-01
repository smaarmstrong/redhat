An application volume already exists and is in use.

There is a volume group  vg_app  containing a logical volume  lv_app
(currently 256 MiB, XFS), already mounted at  /app  and already listed
in /etc/fstab by UUID. The spare disk (the blank one shown by `lsblk`,
typically /dev/vdb) provides the volume group's free space.

Requirements:

  • Extend  lv_app  so it is 512 MiB in size.
  • Grow the XFS filesystem so that `df -h /app` reports the new size.
  • Do all of this WITHOUT unmounting /app — it must stay mounted the
    whole time.

The mount is already persistent by UUID (extending an LV keeps the same
UUID), so you do not need to edit /etc/fstab.
