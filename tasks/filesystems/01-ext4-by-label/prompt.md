Create an ext4 filesystem and mount it by label.

The spare disk is the blank one shown by `lsblk` (typically /dev/vdb, with
no partitions and no mountpoints). Do NOT touch the root disk.

Requirements:

  • Create a partition on the spare disk (any reasonable size, e.g. use the
    whole disk or a few hundred MiB).
  • Make an ext4 filesystem on it with the label   backup
  • Mount it at   /backup
  • Make the mount PERSISTENT across reboot, and in /etc/fstab reference the
    filesystem BY LABEL (the source field must be  LABEL=backup ), not by
    device path or UUID.

After a reboot the filesystem must mount automatically at /backup.
