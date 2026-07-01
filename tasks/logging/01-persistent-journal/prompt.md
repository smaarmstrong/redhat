By default this system keeps journald logs only in memory, so they are lost
on every reboot.

Configure **systemd-journald** to store its logs **persistently** on disk so
that journal entries survive a reboot.

This means:

  • the journal storage directory /var/log/journal must exist, and
  • journald must be configured with Storage=persistent (either in
    /etc/systemd/journald.conf or a drop-in under
    /etc/systemd/journald.conf.d/).
