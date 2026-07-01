The file /var/www/page.html has been given the WRONG SELinux context.

Its path already maps to the correct default type in the system policy
(files under /var/www default to `httpd_sys_content_t`) — someone has
simply mislabelled this one file.

Restore the DEFAULT SELinux context on /var/www/page.html.

A grader will run `ls -Z /var/www/page.html` and expect the type to be
`httpd_sys_content_t`. No new policy rule is needed here; just put the
file's label back to the policy default.
