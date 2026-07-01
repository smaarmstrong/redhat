SELinux is currently in permissive mode.

Put SELinux into ENFORCING mode right now, and make enforcing the mode
the system boots into. Both must be true: the running mode must be
Enforcing, and the setting must PERSIST across a reboot (a grader checks
`getenforce` and /etc/selinux/config).
