Set up a shared directory for a team of developers.

  • Create a group named `developers`.
  • Create the directory /srv/devshare.
  • The directory's group owner must be `developers`.
  • Set the mode to 2770, meaning:
      – the set-GID bit is on (new files inherit the `developers` group),
      – the owner and group have full rwx access,
      – other users have no access at all.

These settings must persist after a reboot (ordinary filesystem
permissions already do).
