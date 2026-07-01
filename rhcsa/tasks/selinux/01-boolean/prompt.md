Turn ON the SELinux boolean `httpd_can_network_connect`.

The change must be PERSISTENT: it has to survive a reboot (a grader
reboots the machine and re-checks). A runtime-only toggle is not enough.
