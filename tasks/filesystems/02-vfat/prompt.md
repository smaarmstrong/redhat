Create a VFAT filesystem and mount it by UUID.

The spare disk is the blank one shown by `lsblk` (typically /dev/vdb, with
no partitions and no mountpoints). Do NOT touch the root disk.

Requirements:

  • Create a partition of about 200 MiB on the spare disk.
  • Make a VFAT filesystem on it  (mkfs.vfat, from the dosfstools package).
  • Mount it at   /mnt/vfat
  • Make the mount PERSISTENT across reboot, referenced BY UUID in
    /etc/fstab (the source field must be  UUID=... ), not by device path.

After a reboot the filesystem must mount automatically at /mnt/vfat.

Note: a VFAT UUID is short (e.g. 1234-ABCD). Use it exactly as blkid
reports it in the fstab line.
