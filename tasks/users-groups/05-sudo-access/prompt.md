Create an administrator account and give it full sudo privileges:

  • User:  create a local user named `opsadmin`
  • Sudo:  grant opsadmin the ability to run ANY command via sudo,
           persistently. Either add opsadmin to the `wheel` group, or
           create a validated file under /etc/sudoers.d/ that grants
           opsadmin ALL privileges.

The account and the sudo rule are stored on disk (/etc/passwd,
/etc/group, /etc/sudoers.d/), so they persist across a reboot.
