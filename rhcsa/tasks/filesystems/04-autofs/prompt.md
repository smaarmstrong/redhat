Configure autofs to auto-mount an NFS share on demand.

This machine is already exporting a directory over NFS to localhost:

    localhost:/srv/share

(confirm with `showmount -e localhost`).

Requirements:

  • Install and enable the  autofs  service (start it, and make it start at
    boot).
  • Configure autofs so that accessing   /mnt/auto/share   automatically
    mounts   localhost:/srv/share   under it.
  • After configuration, simply doing   ls /mnt/auto/share   must trigger the
    mount (autofs mounts on access, so /mnt/auto/share does NOT show up in a
    plain `mount` listing until you touch it).

The mapping must survive a reboot (autofs enabled + config on disk).

This task does NOT use the spare disk.

Hint: add an indirect map to /etc/auto.master (or a file in
/etc/auto.master.d/), e.g.
    /mnt/auto   /etc/auto.share
and in /etc/auto.share:
    share   -fstype=nfs   localhost:/srv/share
then reload autofs.
