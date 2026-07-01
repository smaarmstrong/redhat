Using pipes and output redirection, create the file /root/users.txt.

It must contain the sorted, de-duplicated list of login names taken from
the first field of /etc/passwd — one name per line.

Hints:
  • The first (colon-separated) field of each /etc/passwd line is the login name.
  • Extract that field, then sort and remove duplicates.
  • Redirect the result into /root/users.txt.
