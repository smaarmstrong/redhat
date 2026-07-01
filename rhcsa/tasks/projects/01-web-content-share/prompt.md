PROJECT: Web content area for the dev team

The web team needs a shared area for static site content. You must carve it out
of the spare disk with LVM, make it a setgid collaborative directory for the
web developers, label it so Apache (SELinux) may serve it, and open the firewall
for HTTP. Everything must survive a reboot.

The spare disk is the blank, unpartitioned one shown by `lsblk` (typically
/dev/vdb — confirm it has no partitions and no mountpoints; do NOT touch the
root disk).

Requirements:

  1. On the spare disk, create a physical volume, a volume group named
     vg_web, and a 1 GiB logical volume named lv_web in that group.

  2. Put an XFS filesystem on lv_web and mount it at /srv/www. The mount
     must be PERSISTENT across reboot, referenced BY UUID in /etc/fstab
     (not by device path).

  3. Create a group named webdev.

  4. Make /srv/www group-owned by webdev with mode 2775 — that is, the
     setgid bit set so new files inherit the webdev group, group-writable,
     world-readable/executable but not world-writable.

  5. Set the SELinux file-context TYPE of /srv/www (and its contents) to
     httpd_sys_content_t, and make the labelling PERSISTENT (a rule that
     survives restorecon and reboot), then apply it.

  6. Open the http service in firewalld PERMANENTLY and reload so it is
     active now and after reboot.

After you finish, /srv/www must remount on boot, carry the correct group,
mode, and SELinux type, and the firewall must permit HTTP.
