Harden the SSH server so that it **no longer accepts password logins** —
only key-based authentication should be allowed.

Requirements:

  • The effective SSH server setting must be `PasswordAuthentication no`.
    You may edit `/etc/ssh/sshd_config` directly, or add a drop-in file
    under `/etc/ssh/sshd_config.d/`.
  • The configuration must be syntactically valid (`sshd -t` passes).
  • Reload sshd so the change takes effect.

`PermitRootLogin` may be left as it is — only the password setting matters.

This change must persist across a reboot.
