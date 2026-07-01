Write an executable shell script:

  /usr/local/bin/checkpath.sh

It takes exactly one argument ($1), a filesystem path, and:

  • prints  EXISTS   if that path exists
  • prints  MISSING  if it does not

Use a conditional (if / test / [ ]). The script must be executable.

Examples:
  checkpath.sh /etc/passwd      ->  EXISTS
  checkpath.sh /no/such/thing   ->  MISSING
