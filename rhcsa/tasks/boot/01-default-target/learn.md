THE IDEA

  systemd (the thing that starts everything on a modern RHEL/Rocky system)
  boots the machine into a "target" — a named bundle of services that
  represents a state the system can be in. Two matter for the exam:

    graphical.target    full desktop: everything above, plus a login GUI
    multi-user.target   a full multi-user, networked, text-mode system
                        (no graphical login) — this is what servers run

  The "default target" is simply the one systemd boots into when nobody
  says otherwise. Under the hood it's just a symlink:

    /etc/systemd/system/default.target  ->  .../multi-user.target

  You never edit that symlink by hand — one command manages it.


WHY IT MATTERS

  Servers almost never run a GUI (it wastes RAM and widens the attack
  surface), so "make this box boot to text mode" is a classic exam task and
  a real day-one sysadmin job. "Persist across reboots" is the golden rule
  of the whole exam: a change that vanishes on reboot scores zero.


HOW TO DO IT

  See the current default:

    $ systemctl get-default
    graphical.target

  Set a new default (this rewrites the symlink for you, permanently):

    $ sudo systemctl set-default multi-user.target
    Removed /etc/systemd/system/default.target.
    Created symlink /etc/systemd/system/default.target -> /usr/lib/systemd/system/multi-user.target.

  That's the whole task. Setting the default does NOT switch you right now —
  it takes effect on the next boot. (If you ever want to switch immediately
  without rebooting, that's `systemctl isolate multi-user.target`, but the
  task only asks for the default.)


CHECK IT WORKED

    $ systemctl get-default
    multi-user.target

  That's exactly what the grader checks: the persistent default target.


GOTCHAS

  - Don't just `isolate` to multi-user and think you're done — isolate
    changes the running state now but leaves the DEFAULT untouched, so the
    next reboot goes right back. The grader checks the default, so you'd fail.
  - The name is `multi-user.target`, with the `.target` suffix. `systemctl
    set-default multi-user` also works (systemd is forgiving), but get in the
    habit of the full unit name.
