Add the following argument to the kernel command line:

  rd.md=0

(This is a harmless dracut option that disables MD RAID assembly in the
initramfs — it will not affect this machine's ability to boot.)

Two things are required:

  1. Apply it to ALL currently installed kernels so it takes effect on the
     next boot (use grubby).

  2. Also add it to GRUB_CMDLINE_LINUX in /etc/default/grub so that any
     kernel installed in the future inherits it too.

The change must persist across reboots.
