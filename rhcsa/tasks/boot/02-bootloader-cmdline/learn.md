THE IDEA

  When the machine boots, GRUB (the bootloader) hands the kernel a single
  line of options called the "kernel command line" — which root filesystem to
  use, whether to show a boot splash, low-level driver and tuning flags, and
  so on. Adding or removing an option here is how you change kernel behaviour
  at boot.

---

  You can see the line the RUNNING kernel booted with. Run:

```run
cat /proc/cmdline
```

  Those space-separated tokens (root=..., ro, rhgb, quiet, ...) are the
  kernel command line. We're going to add one more: `rd.md=0` (a harmless
  dracut option — it just disables MD-RAID assembly in the initramfs; the
  skill here is the mechanism, not this particular flag).

---

THE CATCH: TWO PLACES

  The command line lives in two places, and a complete change touches both:

    1. The entries for kernels ALREADY installed, so it takes effect on the
       next boot. On RHEL 9 these are "BLS" files under /boot/loader/entries/.
       You don't edit them by hand — a tool called `grubby` does.

    2. A template, /etc/default/grub (the variable GRUB_CMDLINE_LINUX), so
       that any kernel installed in the FUTURE inherits the option too.

  Do only #1 and a future kernel update silently drops your option. Do only
  #2 and your current kernels never get it. The exam wants both — and that
  two-places trap is exactly what it's testing.

---

STEP 1 — every installed kernel, via grubby

  Note: the boot entries grubby edits live under /boot and the template
  /etc/default/grub is owned by root; you're a normal user, so the
  commands that change them are prefixed with `sudo` — a normal user
  who's been granted sudo, exactly the exam setup. (Reading needs no
  sudo, which is why `cat /proc/cmdline` didn't.)

  Apply the argument to all current kernels:

```run
sudo grubby --update-kernel=ALL --args="rd.md=0"
```

  Now confirm grubby took it (look at the default kernel's args):

```run
sudo grubby --info=DEFAULT | grep args
```

  You should see rd.md=0 in that line.

---

STEP 2 — future kernels, via /etc/default/grub

  /etc/default/grub is a plain text file. First just look at the line we care
  about — the one starting with GRUB_CMDLINE_LINUX:

```run
grep GRUB_CMDLINE_LINUX /etc/default/grub
```

  See the options sitting inside the double quotes (things like "crashkernel...
  rhgb quiet")? We need to add  rd.md=0  in there, inside those quotes. The
  honest way — and the way the exam expects — is to open the file and type it
  in. Open it now:

```run
sudo vi /etc/default/grub
```

  A 20-second vi guide for exactly this edit:
    - Arrow-key onto the GRUB_CMDLINE_LINUX line, just before the closing " .
    - Press  i  to start typing (that's "insert" mode).
    - Type a space, then  rd.md=0
    - Press  Esc  to stop typing.
    - Type  :wq  and press Enter  (write, then quit).
  Prefer nano? Run  sudo nano /etc/default/grub , add the text, then Ctrl-O
  Enter to save and Ctrl-X to quit. Either editor is fine.

---

  Check your edit landed — the option should now be in the line, still inside
  the quotes:

```run
grep GRUB_CMDLINE_LINUX /etc/default/grub
```

  On RHEL 9 you do NOT need `grub2-mkconfig` for this — grubby already
  updated the live boot entries, and /etc/default/grub is only a template for
  the future. (Regenerating won't hurt, but it isn't required.)

---

CHECK IT WORKED

  The grader checks both places — the installed kernels (via grubby) and the
  template. You just verified both above.

---

GOTCHAS

  - Two places. Passing grubby but forgetting /etc/default/grub (or vice
    versa) is the usual way to half-fail this.
  - Append INSIDE the quotes of GRUB_CMDLINE_LINUX — don't add a second
    GRUB_CMDLINE_LINUX line, and don't leave the option outside the quotes.
  - Yes, there are one-line tricks (with `sed`) that make this edit without
    opening an editor. Save those for when you actually know the tool — editing
    the file by hand is fully exam-legal and much easier to get right.
