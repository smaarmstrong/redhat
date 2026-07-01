Set up a systemd timer that runs a maintenance script once a day.

Create two units under /etc/systemd/system:

  • sitecheck.service — a `Type=oneshot` service that executes
    /usr/local/bin/sitecheck.sh (the script already exists).

  • sitecheck.timer — a timer that triggers sitecheck.service **daily**.

Enable the timer so it is active after a reboot, and make sure it shows up
in `systemctl list-timers`.
