THE IDEA

  Mounting a filesystem so it survives a reboot is really two actions: mount it
  now, and add a line to /etc/fstab so it comes back. The mount module does
  both, and its `state:` chooses how much:

    ansible.posix.mount

    state: mounted    mounts NOW and writes the fstab entry (both)
    state: present    writes fstab only (no mount now)
    state: unmounted  unmounts now but leaves fstab

  state: mounted is the one that satisfies "works now AND persists". This task
  mounts a small tmpfs (a RAM-backed filesystem) at /mnt/ramdisk with
  size=64m. We also create the mount point first with the file module.

  ansible.posix.mount is in the ansible.posix collection (setup.sh installs
  it) and setup.sh strips any old /mnt/ramdisk entry. Working directory:
  /root/rhce/mount/.

---

  Check the starting state — nothing mounted, no fstab line:

```run
findmnt /mnt/ramdisk 2>&1 || echo "(not mounted)"; grep ramdisk /etc/fstab 2>/dev/null || echo "(no fstab entry)"
```

  Both absent. Your playbook creates the mount point, mounts the tmpfs, and
  records it in fstab.

---

WHY IT MATTERS

  "Mount filesystems, persist them across reboot" is core RHCSA, and the
  reboot-persistence rule is the exam's golden thread. A mount that isn't in
  fstab vanishes on reboot and scores nothing. state: mounted is precisely the
  setting that guarantees both the live mount and the fstab entry — which are
  the two things the grader inspects.

---

HOW TO DO IT

  Write the playbook. First ensure the directory exists (file module,
  state: directory), then mount:

```run
cd /root/rhce/mount
cat > playbook.yml <<'EOF'
---
- name: Mount and persist a tmpfs ramdisk
  hosts: managed
  become: true
  tasks:
    - name: Ensure the mount point exists
      ansible.builtin.file:
        path: /mnt/ramdisk
        state: directory
        mode: '0755'

    - name: Mount a tmpfs and persist it in fstab
      ansible.posix.mount:
        path: /mnt/ramdisk
        src: tmpfs
        fstype: tmpfs
        opts: size=64m
        state: mounted
EOF
```

  path is the mount point; for a tmpfs the src is literally the word `tmpfs`
  (there's no device); fstype: tmpfs; opts carries mount options (size=64m
  caps it at 64 MB). state: mounted does the mount and the fstab write in one
  go.

---

  Run it:

```run
cd /root/rhce/mount && ansible-playbook playbook.yml
```

  changed=2 (directory + mount). Re-run for the idempotence check:

```run
cd /root/rhce/mount && ansible-playbook playbook.yml
```

  changed=0 — the directory exists, it's already mounted, and the fstab line
  is already there, so nothing changes.

---

CHECK IT WORKED

  The grader verifies /mnt/ramdisk is mounted as tmpfs AND that fstab has a
  tmpfs entry for it. Check both:

```run
findmnt -no FSTYPE /mnt/ramdisk
grep /mnt/ramdisk /etc/fstab
```

  First should print `tmpfs`; second should show a line with /mnt/ramdisk and
  tmpfs — the persistent half.

---

GOTCHAS

  - state: mounted, not state: present. present writes fstab but doesn't mount
    now; mounted does both, which is what "works now and persists" requires.
  - For tmpfs the src is the string `tmpfs`, not a /dev path — there's no
    backing device.
  - Create the mount point (the file task). If /mnt/ramdisk doesn't exist the
    mount can fail; state: directory is idempotent so it's safe to always
    include.
  - Fully-qualified name ansible.posix.mount; install the collection if the
    module isn't found (setup.sh already tried).
