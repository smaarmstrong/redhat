Mount an NFS share and make the mount persistent.

This machine is already exporting a directory over NFS to localhost:

    localhost:/srv/share

(The export is set up for you; confirm it with `showmount -e localhost`.)

Requirements:

  • Mount the NFS export   localhost:/srv/share   at   /mnt/nfs
  • Make the mount PERSISTENT across reboot by adding it to /etc/fstab with
    fstype  nfs  (or nfs4). Use the  _netdev  option so it is treated as a
    network mount at boot.

After a reboot the share must mount automatically at /mnt/nfs.

This task does NOT use the spare disk.

Hint: an fstab NFS line looks like
    localhost:/srv/share  /mnt/nfs  nfs  _netdev  0 0
