Add the SELinux port label so that TCP port 8888 is typed `http_port_t`.

The label must be PERSISTENT: it has to survive a reboot (a grader
reboots and re-checks with `semanage port -l`).
