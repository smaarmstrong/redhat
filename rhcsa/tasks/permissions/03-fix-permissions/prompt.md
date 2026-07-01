A report file has been left with the wrong ownership and permissions,
and the user `intern` cannot read it.

  • The file is /srv/reports/report.txt.
  • Make it so the user `intern` can READ the file.
  • `intern` must also be able to reach the file — that is, `intern`
    needs to be able to traverse the /srv/reports directory.
  • Any correct fix is acceptable (adjust ownership, group, mode, or an
    ACL) as long as `intern` ends up able to read the file. Do NOT
    solve it by making the file world-writable or handing out more
    access than needed if you can avoid it.

The fix must persist after a reboot.
