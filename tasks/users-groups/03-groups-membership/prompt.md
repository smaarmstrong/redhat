Set up a shared group and two members:

  • Group:  create a group named `engineers` with GID 4000
  • Users:  create two local users, `alice` and `bob`
  • Membership: both alice and bob must have `engineers` as a
                supplementary group (it need not be their primary group)

These are ordinary local accounts and groups recorded in /etc/passwd,
/etc/group and /etc/shadow, so they persist across a reboot.
