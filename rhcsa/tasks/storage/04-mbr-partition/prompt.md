Create an MBR (MS-DOS) partition and mount it by UUID.

The spare disk is the blank one shown by `lsblk` (typically /dev/vdb, with
no partitions and no mountpoints). Do NOT touch the root disk.

Requirements:

  • Put an MS-DOS / MBR partition table on the spare disk (not GPT).
  • Create ONE primary partition of about 300 MiB on it.
  • Make an ext4 filesystem on that partition.
  • Mount it at   /mnt/mbrpart
  • Make the mount PERSISTENT across reboot, referenced BY UUID in
    /etc/fstab (the source field must be  UUID=... ), not by device path.

After a reboot the filesystem must mount automatically at /mnt/mbrpart.

Hint: `parted -s <disk> mklabel msdos` creates an MBR label; then create a
primary partition, e.g. `parted -s <disk> mkpart primary ext4 1MiB 301MiB`.
