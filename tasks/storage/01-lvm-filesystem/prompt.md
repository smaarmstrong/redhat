Build an LVM stack on the spare disk.

The spare disk is the blank, unpartitioned one shown by `lsblk` (on this
machine it is typically /dev/vdb — confirm with `lsblk` that it has no
partitions and no mountpoints; do NOT touch the root disk).

Requirements:

  • Create a physical volume on the spare disk.
  • Create a volume group named   vg_data
  • Create a logical volume named  lv_files  of size 512 MiB in vg_data
  • Put an XFS filesystem on lv_files
  • Mount it at /data
  • Make the mount PERSISTENT across reboot, referenced BY UUID in
    /etc/fstab (not by device path).

After you are done the filesystem must remount automatically on boot.
