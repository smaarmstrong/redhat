Create a Stratis pool and filesystem, mounted persistently.

(BONUS — this is a RHEL 8-era objective. Stratis manages pooled storage on
top of your disks.)

The spare disk is the blank one shown by `lsblk` (typically /dev/vdb, with
no partitions and no mountpoints). Do NOT touch the root disk.

Requirements:

  • Make sure the  stratisd  service is running (it must be, for the CLI to
    work).
  • Create a Stratis pool named   pool1   on the spare disk.
  • Create a Stratis filesystem named   fs1   in that pool.
  • Mount it at   /mnt/stratis
  • Make the mount PERSISTENT across reboot. Because Stratis devices appear
    only after stratisd starts, the fstab entry MUST carry the option
        x-systemd.requires=stratisd.service
    You may reference the filesystem by its device path
    (/dev/stratis/pool1/fs1) or by its UUID.

After a reboot the filesystem must mount automatically at /mnt/stratis.

Hint:
    stratis pool create pool1 <disk>
    stratis filesystem create pool1 fs1
    lsblk /dev/stratis/pool1/fs1     # to find the UUID if you use one
