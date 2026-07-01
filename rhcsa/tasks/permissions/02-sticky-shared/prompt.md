Create a public "drop box" directory that everyone can write to, but
where users cannot delete or rename each other's files.

  • Create the directory /srv/dropbox.
  • Make it world-writable (owner, group, and other all get rwx).
  • Set the sticky bit so that only a file's owner (or root) can remove
    or rename that file — like /tmp.
  • The resulting mode must be 1777.

These permissions must persist after a reboot.
