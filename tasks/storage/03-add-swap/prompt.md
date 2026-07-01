Add extra swap space on the spare disk.

The spare disk is the blank one shown by `lsblk` (typically /dev/vdb, with
no partitions and no mountpoints). Do NOT touch the root disk or the
system's existing swap.

Requirements:

  • Create a 256 MiB partition on the spare disk.
  • Format it as swap (mkswap).
  • Activate it now (swapon) so it appears in `swapon --show` / /proc/swaps.
  • Make it PERSISTENT across reboot via /etc/fstab, referenced BY UUID,
    with filesystem type  swap.

After a reboot the new swap must come up automatically alongside the
existing system swap.
