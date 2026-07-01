PROJECT: Mock mini-exam

Eight independent tasks spanning the RHCSA domains. Each is graded separately,
so partial credit is possible — but as on the real exam, EVERY configuration
must persist across a reboot.

The spare disk is the blank, unpartitioned one shown by `lsblk` (typically
/dev/vdb — confirm it has no partitions and no mountpoints; do NOT touch the
root disk).

  a) Create a user named examuser who is a member of the wheel group.

  b) Create a 256 MiB swap area on the spare disk and enable it. It must be
     active now and re-enable on boot, referenced BY UUID in /etc/fstab.

  c) The chronyd time service must be enabled and running.

  d) In firewalld, open port 8080/tcp PERMANENTLY (active now and after
     reboot).

  e) Set the system default target to multi-user.target.

  f) Put SELinux in enforcing mode now AND in /etc/selinux/config so it stays
     enforcing after reboot.

  g) Create a root cron job that runs /usr/local/bin/report.sh every day at
     06:00. (The script itself need not exist for this task.)

  h) Create the directory /opt/shared with mode 1777 (world-writable with the
     sticky bit, like /tmp).
