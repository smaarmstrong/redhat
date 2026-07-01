The file /web/index.html currently has the WRONG SELinux type.

Give /web/index.html the SELinux type `httpd_sys_content_t`.

The context must be PERSISTENT: it has to survive a relabel and a reboot
(a grader may run `restorecon` and reboot, then re-check). Simply using
`chcon` is not enough on its own — add a file-context rule so the default
type is correct, then apply it.
