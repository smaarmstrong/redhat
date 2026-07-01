Work in /root/rhce/mount/. Write `playbook.yml` that uses the
`ansible.posix.mount` module to mount a small **tmpfs** at `/mnt/ramdisk` on the
hosts in the `managed` group and persist it in `/etc/fstab`:

- fstype `tmpfs`
- a small size option (e.g. `size=64m`)
- `state: mounted` (mounts now AND writes the fstab entry so it survives a reboot)

Create the mount point if needed. Run it with `ansible-playbook`. Your playbook
must be idempotent (a second run changes nothing).
