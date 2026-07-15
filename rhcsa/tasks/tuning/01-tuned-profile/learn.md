THE IDEA

  tuned is a service that applies a bundle of low-level system settings —
  CPU governor, disk readahead, kernel VM knobs, power management — chosen
  to suit a workload. Each bundle is a named "profile". Instead of tuning a
  dozen sysctls by hand, you pick a profile and tuned applies the lot.

  Common profiles include:

    balanced     a sensible default for most machines
    powersave    favours lower power draw over peak performance
    throughput-performance   favours raw throughput (servers)
    virtual-guest            tuned for VMs

  You manage all of this with one tool: tuned-adm.

---

  The system starts on the balanced profile. Confirm what's active now:

```run
tuned-adm active
```

  It reports "Current active profile: balanced". You can also see every
  profile available on this box:

```run
tuned-adm list
```

  powersave should be in that list — that's the one we're switching to.

---

WHY IT MATTERS

  "Manage tuning profiles" is a stated objective, and picking the right
  profile is a genuine operational lever — a laptop or a power-conscious
  server wants powersave; a database host wants a performance profile.
  Knowing the tuned-adm verbs (active, list, profile) is the whole skill.

  tuned records the chosen profile persistently, so the selection survives a
  reboot on its own — as long as the tuned service is enabled to come back
  up.

---

HOW TO DO IT

  Note: enabling the tuned service writes a boot-time symlink under
  /etc and tuned-adm records the profile under /etc/tuned/, both owned
  by root, so those commands are prefixed with `sudo` — a normal user
  who's been granted sudo, exactly the exam setup. (Reading needs no
  sudo, which is why the earlier `tuned-adm active` didn't.)

  First make sure the tuned service is enabled and running, so it's there
  now and after a reboot. enable --now does both in one go:

```run
sudo systemctl enable --now tuned
```

  Now switch the active profile to powersave. tuned applies it immediately
  and remembers the choice:

```run
sudo tuned-adm profile powersave
```

  That's it — no config file to edit by hand. tuned writes the selection to
  its own state (under /etc/tuned/) so the next boot restores it.

---

CHECK IT WORKED

  Ask tuned what's active — this is exactly what the grader parses:

```run
tuned-adm active
```

  It should now read "Current active profile: powersave".

  You can also confirm the service will survive a reboot:

```run
systemctl is-enabled tuned
```

  "enabled" means tuned starts at boot and re-applies the saved profile.

---

GOTCHAS

  - Set the profile by its exact name, powersave. `tuned-adm list` shows the
    valid names — a typo just errors.
  - If tuned isn't enabled, a reboot could leave the profile unapplied. The
    profile choice persists, but the service that applies it must start —
    hence enable --now.
  - `tuned-adm off` disables all tuning (no active profile) — that's the
    opposite of what we want here.
  - Verify with `tuned-adm active`, not by guessing from system behaviour.
