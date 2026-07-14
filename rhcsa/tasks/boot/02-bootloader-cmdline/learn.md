THE IDEA

  When the machine boots, GRUB (the bootloader) hands the kernel a single
  line of options called the "kernel command line" — things like which root
  filesystem to use, whether to show a boot splash, and low-level tuning
  flags. You can see the line the running kernel booted with:

    $ cat /proc/cmdline
    BOOT_IMAGE=... root=/dev/mapper/rl-root ro rhgb quiet

  Adding or removing an option here is how you change kernel behaviour at
  boot (enable/disable a feature, pass a driver flag, turn off the graphical
  boot, etc.).

  The catch: there are TWO places this line lives, and a complete change
  touches both —

    1. The entries for the kernels ALREADY installed (so it takes effect on
       the next boot). On RHEL 9 these live under /boot/loader/entries/ in
       "BLS" (Boot Loader Spec) files. You don't edit them by hand — a tool
       called `grubby` does it.

    2. A template, /etc/default/grub, so that any kernel installed in the
       FUTURE inherits the option too. The relevant variable is
       GRUB_CMDLINE_LINUX.

  Do only #1 and a future kernel update silently drops your option. Do only
  #2 and your currently-installed kernels never get it. The exam wants both.


WHY IT MATTERS

  "Add a kernel argument, permanently" is a standard exam objective, and the
  two-places trap is exactly what it's testing — whether you know that
  grubby handles existing kernels and /etc/default/grub handles future ones.


HOW TO DO IT

  Apply the argument to every currently installed kernel:

    $ sudo grubby --update-kernel=ALL --args="rd.md=0"

  Confirm grubby took it (look at the default kernel's args):

    $ sudo grubby --info=DEFAULT | grep args

  Then make future kernels inherit it. Edit /etc/default/grub and append the
  option inside the quotes of the existing GRUB_CMDLINE_LINUX line, e.g.:

    GRUB_CMDLINE_LINUX="... rhgb quiet rd.md=0"

  You can do that in an editor, or in one line:

    $ sudo sed -i 's/^\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 rd.md=0"/' /etc/default/grub

  Note: on RHEL 9 you do NOT need to run `grub2-mkconfig` for this — grubby
  already updated the live boot entries, and /etc/default/grub is only a
  template for the future. (Regenerating won't hurt, but it isn't required.)


CHECK IT WORKED

    $ sudo grubby --info=DEFAULT | grep args     # should contain rd.md=0
    $ grep GRUB_CMDLINE_LINUX /etc/default/grub   # should contain rd.md=0

  The grader checks both: the installed kernels via grubby, and the template
  in /etc/default/grub.


GOTCHAS

  - Two places, remember. Passing grubby but forgetting /etc/default/grub
    (or vice-versa) is the usual way to half-fail this.
  - Append INSIDE the quotes of GRUB_CMDLINE_LINUX — don't add a second
    GRUB_CMDLINE_LINUX line, and don't leave the option outside the quotes.
  - `rd.md=0` here is deliberately harmless (it just disables MD-RAID
    assembly in the initramfs); the skill is the mechanism, not this flag.
