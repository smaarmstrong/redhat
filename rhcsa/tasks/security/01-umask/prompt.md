Make the default umask for interactive login shells `077`, so that newly
created files default to permissions 600 and directories to 700.

Requirements:

  • Create /etc/profile.d/umask.sh that sets `umask 077`.
  • The setting must be PERSISTENT: a fresh login shell must apply it,
    and it must survive a reboot.

A grader will start a fresh login shell and check that `bash -lc umask`
reports `0077`.
