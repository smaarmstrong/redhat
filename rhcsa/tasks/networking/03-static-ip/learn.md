THE IDEA

  On RHEL/Rocky 9 the network is run by NetworkManager, and the key thing to
  get straight is the difference between a DEVICE and a CONNECTION:

    device      the actual network interface (a NIC, or here a dummy)
    connection  a saved PROFILE of settings — address, gateway, DNS,
                whether to autoconnect — that gets applied to a device

  You don't configure the device directly; you edit a connection profile and
  NetworkManager applies it. The profile is a file on disk (under
  /etc/NetworkManager/system-connections/), which is why the settings
  persist across reboots. The command-line tool for all of this is nmcli.

---

  For this task a connection profile called dummy0 already exists, sitting on
  a harmless dummy interface — so nothing we do here can knock the machine
  off the network. Let's see how it's configured right now:

```run
nmcli connection show dummy0 | grep ipv4
```

  You'll see ipv4.method is auto and the address/gateway/dns fields are
  empty — the neutral starting state we need to turn into a static setup.

---

WHY IT MATTERS

  Servers almost always need a fixed IP address — DHCP handing out a
  different address each boot is fine for a laptop, useless for something
  other machines connect to. "Give this box a static IPv4 config" is one of
  the most common networking tasks there is, on the exam and in real life.
  And it must persist: a live-only address set with `nmcli device` or `ip
  addr add` vanishes on reboot and scores nothing.

---

HOW TO DO IT

  The whole job is one `nmcli connection modify` command that writes several
  properties into the profile at once. The pieces:

    ipv4.method manual        switch off DHCP; we supply the address
    ipv4.addresses 10.10.10.5/24   the IP plus its prefix (/24 = netmask)
    ipv4.gateway 10.10.10.1   the default route
    ipv4.dns 10.10.10.53      the DNS server to query
    connection.autoconnect yes    bring it up automatically at boot

  Setting method to manual is the crucial switch — without it NetworkManager
  ignores your static address and keeps asking DHCP. Run it:

```run
sudo nmcli connection modify dummy0 ipv4.method manual ipv4.addresses 10.10.10.5/24 ipv4.gateway 10.10.10.1 ipv4.dns 10.10.10.53 connection.autoconnect yes
```

  No output means it took. modify only WRITES the profile to disk — it
  doesn't re-apply it to the live device. On a real interface you'd follow up
  with `nmcli connection up dummy0` to activate it now; the grader here only
  cares about the saved profile, so that step is optional for us.

---

CHECK IT WORKED

  The grader reads each property straight out of the profile with `nmcli -g`
  (get one field). Confirm them the same way:

```run
nmcli -g ipv4.method,ipv4.addresses,ipv4.gateway,ipv4.dns,connection.autoconnect connection show dummy0
```

  You should see, one per line: manual, 10.10.10.5/24, 10.10.10.1,
  10.10.10.53, yes. That's every value the grader checks.

---

GOTCHAS

  - Remember ipv4.method manual. Setting an address but leaving the method
    on auto is the classic half-fail — the static config is stored but never
    used.
  - The address needs its prefix: 10.10.10.5/24, not a bare 10.10.10.5.
    Without the /24 nmcli won't know the netmask.
  - Edit the CONNECTION, not the device. `ip addr add ...` or `nmcli device`
    changes are runtime-only and disappear on reboot — modify the profile so
    it persists.
  - Property names are dotted: ipv4.addresses, connection.autoconnect. Get
    the prefix right (ipv4. vs connection.) or nmcli rejects the key.
