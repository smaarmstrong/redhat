THE IDEA

  systemd — the thing that starts everything on a modern RHEL/Rocky system —
  boots the machine into a "target": a named bundle of services that
  represents a state the system can be in. Two targets matter for the exam:

    graphical.target    a full desktop, including a login GUI
    multi-user.target   a full multi-user, networked, TEXT-mode system
                        (no graphical login) — what servers actually run

  The "default target" is simply the one systemd boots into when nobody says
  otherwise. Under the hood it's just a symlink at
  /etc/systemd/system/default.target — but you never touch that by hand; one
  command manages it.

---

  Let's see where this machine boots today. Run:

```run
systemctl get-default
```

  On a desktop install that prints `graphical.target`. That's the state the
  box comes up in every time it powers on.

---

WHY IT MATTERS

  Servers almost never run a GUI — it wastes memory and widens the attack
  surface — so "make this box boot to text mode" is both a classic exam task
  and a real day-one sysadmin job. And note the exam's golden rule already
  showing up: the change has to survive a reboot, or it scores nothing.

---

HOW TO DO IT

  One command sets the default and rewrites that symlink for you,
  permanently. Go ahead and run it:

```run
sudo systemctl set-default multi-user.target
```

  See how it tells you it removed the old symlink and created a new one
  pointing at multi-user.target? That's the whole task.

  Important: this does NOT switch you to text mode right now — it takes
  effect on the NEXT boot. (If you ever needed to switch immediately without
  rebooting, that's `systemctl isolate`, but the task only asks for the
  default.)

---

CHECK IT WORKED

  Confirm the new default:

```run
systemctl get-default
```

  `multi-user.target` — exactly what the grader looks for: the persistent
  default target.

---

GOTCHAS

  - Don't just `isolate` to multi-user and call it done. isolate changes the
    running state now but leaves the DEFAULT untouched, so the next reboot
    goes right back — and the grader checks the default, so you'd fail.
  - Use the full unit name, `multi-user.target`. (`set-default multi-user`
    happens to work because systemd is forgiving, but build the habit.)
