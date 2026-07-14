THE IDEA

  NFS (Network File System) lets one machine share a directory over the
  network and another machine mount it as if it were local. Here you are
  the CLIENT: a directory is already being exported by a server, and your
  job is to mount it and make that mount stick.

  A network mount looks almost like a local one in /etc/fstab, with two
  differences:

    - the source is  host:/path  (server and remote path), not a device
    - it needs the  _netdev  option, which tells systemd "this depends on
      the network — wait for networking before mounting, and unmount it
      before the network goes down at shutdown"

  This task does NOT use the spare disk; it's purely about the client side.

---

  Conveniently, this machine exports a share to itself (localhost), so
  there's a real server to talk to. Confirm the export exists:

```run
showmount -e localhost
```

  You should see /srv/share listed. That's what we'll mount at /mnt/nfs.

---

WHY IT MATTERS

  Mounting NFS shares is bread-and-butter sysadmin work — home directories,
  shared project trees, and software repos all commonly live on an NFS
  server. It's a listed objective, and the persistence rule applies: a live
  `mount` is gone after reboot, so the exam wants it in /etc/fstab, with
  _netdev so it's handled correctly as a network mount.

---

HOW TO DO IT

  Step 1 — create the mountpoint directory:

```run
sudo mkdir -p /mnt/nfs
```

---

  Step 2 — add the persistent fstab entry. Source is the export
  (localhost:/srv/share), fstype is nfs, and the key option is _netdev:

```run
echo "localhost:/srv/share  /mnt/nfs  nfs  _netdev  0 0" | sudo tee -a /etc/fstab
```

---

  Step 3 — mount it. Because there's already an fstab line, you can mount
  by just naming the mountpoint — systemd/mount reads the rest from fstab:

```run
sudo systemctl daemon-reload; sudo mount /mnt/nfs
```

```run
findmnt /mnt/nfs
```

  findmnt should show /mnt/nfs with FSTYPE nfs (or nfs4) and the source
  localhost:/srv/share.

---

  Step 4 — prove it's really the remote share by reading the marker file
  the server put there:

```run
cat /mnt/nfs/README
```

---

CHECK IT WORKED

  The grader checks: /mnt/nfs is mounted as nfs/nfs4, and fstab has an
  entry for /mnt/nfs whose fstype is nfs/nfs4 and whose source looks like
  host:/path. Quick look:

```run
findmnt /mnt/nfs; grep nfs /etc/fstab
```

---

GOTCHAS

  - Use _netdev. Without it, boot may try to mount before the network is
    up and fail — and it's what the exam expects on network mounts.
  - The source is host:/path (note the colon), e.g.
    localhost:/srv/share — not a /dev device and not a bare path.
  - The nfs-utils package must be present for the mount to work (setup
    installs it). If showmount can't reach the server, nothing will mount.
  - You do NOT need mkfs, a partition, or the spare disk here — this is
    client-side only.
