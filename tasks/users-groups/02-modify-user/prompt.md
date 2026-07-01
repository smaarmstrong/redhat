An existing local user `webadmin` must be modified. Make these changes:

  • Login shell:   change it to /sbin/nologin
  • Group:         add webadmin to the supplementary group `webteam`
                   (the group already exists — do not remove any other groups)
  • Account state: lock the account so it cannot be used to log in

All of these changes are recorded in /etc/passwd, /etc/group and
/etc/shadow, so they persist across a reboot automatically.
