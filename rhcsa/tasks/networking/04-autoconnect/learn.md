THE IDEA

  On RHEL/Rocky 9, NetworkManager stores each network setup as a CONNECTION
  profile — a saved bundle of settings that gets applied to an interface. One
  of the settings in every profile is connection.autoconnect: a simple yes/no
  flag deciding whether NetworkManager brings this connection up on its own
  when the system boots (or when the device appears).

  If autoconnect is no, the profile just sits there dormant until someone
  activates it by hand. If it's yes, the network comes up automatically. That
  flag lives in the profile file on disk, so it survives reboots.

---

  A connection called netauto already exists here, on a safe dummy interface,
  and setup deliberately left its autoconnect switched OFF. See for yourself:

```run
nmcli -g connection.autoconnect connection show netauto
```

  That prints "no" — the connection won't start on its own. Our job is to
  flip it to yes.

---

WHY IT MATTERS

  A server that doesn't bring its network up at boot is a server you can't
  reach after a reboot — you'd have to walk to the console to activate it by
  hand. Making the connection come up automatically is what you want in
  practice, and "ensure this connection starts at boot" is a straightforward
  exam ask. The change has to persist, so it belongs in the profile, not in
  a one-off command.

---

HOW TO DO IT

  Setting autoconnect is a single property change on the connection profile:

```run
sudo nmcli connection modify netauto connection.autoconnect yes
```

  No output means success. That writes connection.autoconnect=yes into the
  profile on disk, so from the next boot onward NetworkManager will activate
  netauto by itself.

---

CHECK IT WORKED

  The grader confirms the connection exists and reads the autoconnect flag
  straight from the profile. Check it the same way:

```run
nmcli -g connection.autoconnect connection show netauto
```

  It should now read "yes" — exactly what the grader looks for.

---

GOTCHAS

  - Set it on the CONNECTION profile with `nmcli connection modify`.
    Bringing the connection up once with `nmcli connection up` activates it
    now but does NOT change the autoconnect flag, so the next reboot leaves
    it down again.
  - The property is connection.autoconnect (note the connection. prefix),
    and the value is yes/no, not true/false.
  - modify writes the profile; it doesn't necessarily activate the
    connection this instant. That's fine here — the grader checks the
    persistent setting, which is what autoconnect is.
