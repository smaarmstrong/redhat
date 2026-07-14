THE IDEA

  A server with the wrong clock is a real problem: logs don't line up,
  TLS certificates look expired or not-yet-valid, and Kerberos flatly
  refuses to work. So machines keep their clock accurate by talking to NTP
  (Network Time Protocol) time servers. On RHEL/Rocky the NTP client is
  chrony, made of two parts:

    chronyd          the daemon (service) that does the syncing
    /etc/chrony.conf its config, where you list the time servers to use

  Configuring a time client is two moves: point chrony at a server, and make
  sure the chronyd service is enabled and running.

---

  Look at the current config. The lines that matter start with `server` or
  `pool`:

```run
grep -E '^(server|pool)' /etc/chrony.conf
```

  Those are the time sources chrony already uses. We're going to add one
  more: time.cloudflare.com. Setup made sure that line isn't there yet, so
  there's real work to do.

---

WHY IT MATTERS

  "Configure time service clients" is a stated objective, and it's a
  day-one task on any real server. The exam's golden rule applies hard
  here: it must survive a reboot. That means both the config line AND an
  enabled service — a running-but-not-enabled chronyd passes today and fails
  after the next boot.

---

HOW TO DO IT

  First, add the server directive. A `server` line names one NTP server;
  iburst tells chrony to send a quick burst of packets at startup so it
  synchronises faster. Append it to the config:

```run
echo "server time.cloudflare.com iburst" | sudo tee -a /etc/chrony.conf
```

  (You could instead drop this into a new file under /etc/chrony.d/, e.g.
  /etc/chrony.d/cloudflare.conf — chrony reads both. Either place is graded.)

  Now enable and start the service so it runs now and comes back after a
  reboot:

```run
sudo systemctl enable --now chronyd
```

  chronyd re-reads the config on start. (If it was already running, restart
  it — `sudo systemctl restart chronyd` — so it picks up the new line.)

---

CHECK IT WORKED

  The grader checks three things. First, the config points at the server:

```run
grep -R 'time.cloudflare.com' /etc/chrony.conf /etc/chrony.d/ 2>/dev/null
```

  Second and third, that chronyd is enabled (persists) and active (running
  now):

```run
systemctl is-enabled chronyd
systemctl is-active chronyd
```

  Both should print "enabled" and "active". If you have a network route,
  you can also watch chrony's view of its sources — though the task does NOT
  require the clock to actually sync:

```run
chronyc sources 2>/dev/null || true
```

---

GOTCHAS

  - Two parts, both required: the config line AND enable --now. A running
    daemon that isn't enabled fails the reboot rule.
  - Reload after editing. chronyd reads the config at start — if it was
    already up, restart it or your new server line is ignored until reboot.
  - `server` is one host; `pool` is a group of hosts behind one name. The
    task asks for a single `server time.cloudflare.com` line.
  - The service is chronyd (with a d), not "chrony". `systemctl status
    chrony` will confuse you — the unit is chronyd.
  - You don't need the clock to reach "synchronised" — no internet route is
    fine. Only the config and service state are graded.
