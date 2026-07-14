THE IDEA

  This is a mock mini-exam: eight small, INDEPENDENT tasks spanning the
  RHCSA domains, each graded on its own. Unlike the project scenarios,
  nothing here depends on anything else — which changes the strategy. The
  thing being practised is exam TECHNIQUE as much as the individual
  commands. The eight items:

    a) user examuser, member of wheel
    b) 256 MiB swap on the spare disk, persistent by UUID
    c) chronyd enabled and running
    d) firewalld: open 8080/tcp permanently
    e) default target = multi-user.target
    f) SELinux enforcing now AND in config
    g) root cron: /usr/local/bin/report.sh daily at 06:00
    h) /opt/shared at mode 1777 (sticky, world-writable)

---

EXAM STRATEGY

  Before touching anything, work like you would in the real exam:

    - READ ALL EIGHT FIRST. Know the whole board before you start, so you
      can order the work and spot anything that needs a package installed.
    - DO THE QUICK, INDEPENDENT ONES EARLY. Here that's e, h, c, d, a —
      each is one or two commands. Bank easy points fast.
    - LEAVE THE FIDDLY ONE FOR A CLEAR HEAD. The swap task (b) has the most
      steps and the most ways to slip; do it when you're not rushing.
    - VERIFY PERSISTENCE ON EVERY ITEM. Because partial credit is per task,
      one change that doesn't survive reboot only loses THAT task's points
      — but that's still points. fstab, --permanent, is-enabled, the
      SELinux config file: check each one.
    - BUDGET TIME. Eight tasks, ~30 minutes: roughly 3-4 minutes each, and
      don't sink ten minutes into one while three easy ones sit undone.

---

  Confirm the spare disk before the storage task (blank, no partitions, no
  mountpoint — the root disk carries /):

```run
lsblk
```

  The spare here is /dev/vdb. Everything else is off-limits.

---

HOW TO DO IT

  (a) User in wheel. Create examuser, then add to the wheel group with
  -aG (append, don't replace her other groups). Membership in wheel is the
  standard way to grant sudo on RHEL:

```run
sudo useradd examuser
sudo usermod -aG wheel examuser
```

---

  (b) Swap on the spare, 256 MiB, persistent by UUID. Partition it (1MiB
  start for alignment, so 1..257MiB is 256 MiB), tell the kernel to re-read
  the table, then format as swap:

```run
sudo parted -s /dev/vdb mklabel gpt
sudo parted -s /dev/vdb mkpart primary linux-swap 1MiB 257MiB
sudo partprobe /dev/vdb; sleep 1; lsblk /dev/vdb
```

```run
sudo mkswap /dev/vdb1
```

---

  Activate it now, then persist it by UUID. Swap fstab lines are special:
  the mountpoint field is the literal word "none" and the fstype is "swap".
  Finally swapoff/swapon -a to prove the fstab line re-enables it exactly
  as boot would:

```run
sudo swapon /dev/vdb1
uuid=$(sudo blkid -s UUID -o value /dev/vdb1); echo "UUID=$uuid  none  swap  defaults  0 0" | sudo tee -a /etc/fstab
sudo swapoff /dev/vdb1; sudo systemctl daemon-reload; sudo swapon -a; swapon --show
```

---

  (c) chronyd — the time service. Enable and start in one command;
  --now covers "running right now" and enable covers "back after reboot":

```run
sudo systemctl enable --now chronyd
```

---

  (d) Firewall port 8080/tcp. Add it to the PERMANENT config (survives
  reboot) then reload so it's live now too:

```run
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

  (e) Default target. One command rewrites the default.target symlink
  permanently — this takes effect on the next boot, not instantly:

```run
sudo systemctl set-default multi-user.target
```

---

  (f) SELinux enforcing — two places, both required. setenforce 1 flips
  the RUNNING mode now; editing /etc/selinux/config makes it stick across
  reboot. Do only one and you half-fail:

```run
sudo setenforce 1
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
```

  Confirm both: getenforce should say Enforcing, and the config line
  should read SELINUX=enforcing:

```run
getenforce; grep '^SELINUX=' /etc/selinux/config
```

---

  (g) Root cron job, daily at 06:00. The five time fields are minute hour
  day-of-month month day-of-week; "0 6 * * *" means minute 0 of hour 6,
  every day. This appends the line to root's crontab (stripping any old
  copy first so we don't duplicate it):

```run
( sudo crontab -l 2>/dev/null | grep -v '/usr/local/bin/report.sh'; echo "0 6 * * * /usr/local/bin/report.sh" ) | sudo crontab -
```

  The script itself need not exist — the task only asks for the schedule.
  Check it:

```run
sudo crontab -l
```

---

  (h) Sticky world-writable directory. Mode 1777 is the /tmp model: the
  leading 1 is the STICKY bit (users can only delete their OWN files), and
  777 lets everyone read/write/execute:

```run
sudo mkdir -p /opt/shared
sudo chmod 1777 /opt/shared
```

---

CHECK IT WORKED

  Each item is graded separately; the grader looks for examuser in wheel; a
  ~256 MiB swap partition active in /proc/swaps with a matching UUID=swap
  fstab line; chronyd enabled + active; 8080/tcp in both permanent and
  runtime firewall config; default target multi-user.target; getenforce
  Enforcing plus SELINUX=enforcing in config; the root cron line at 06:00;
  and /opt/shared at mode 1777. A one-shot sweep of the quick ones:

```run
id examuser; systemctl is-enabled chronyd; systemctl get-default; getenforce; stat -c %a /opt/shared; sudo firewall-cmd --query-port=8080/tcp
```

---

GOTCHAS

  - Two-places traps: SELinux needs runtime (setenforce) AND config;
    firewall needs --permanent AND a reload; swap needs swapon AND fstab.
  - set-default does NOT switch you to text mode now — it's next boot only.
    Don't `isolate` and assume the default changed; the grader checks the
    default.
  - Swap fstab fields are "none" and "swap"; reference by UUID, never
    /dev/vdb1 (device names can shift between boots).
  - Sticky bit is the leading 1 in 1777 — not setuid (4) or setgid (2).
  - -aG appends to groups; plain -G on usermod would REPLACE examuser's
    group list. Get in the habit of -aG.
  - Partial credit is real: a half-done exam still scores. Do the easy
    items even if one hard task defeats you, and always verify persistence.
