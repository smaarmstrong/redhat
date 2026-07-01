The existing user `appuser` must have its password aging policy adjusted:

  • Maximum password age:  60 days
  • Minimum password age:  1 day
  • Password expiry warning: 7 days

These settings live in /etc/shadow, so they persist across a reboot.
