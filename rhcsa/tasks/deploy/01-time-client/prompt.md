Configure this system's time service (chrony) to synchronise from the
NTP server:

  time.cloudflare.com

Add a line of the form:

  server time.cloudflare.com iburst

to /etc/chrony.conf (or to a drop-in file under /etc/chrony.d/), then make
sure the chronyd service is enabled and running.

You do NOT need the clock to actually reach a synchronised state (this
machine may have no route to the internet) — only the configuration and
service state are graded, and both must persist across a reboot.
