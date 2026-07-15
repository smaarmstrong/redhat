Create two links to an existing file.

  • The source file is /opt/src/original.txt.
  • Create a HARD link named /opt/src/hardlink.txt that refers to the
    same file (same inode) as original.txt.
  • Create a SYMBOLIC (soft) link named /opt/src/symlink.txt that points
    to original.txt.

The links must persist after a reboot (they are stored on disk, so
creating them once is enough).

Note: /opt/src is owned by root, so create the links with sudo.
