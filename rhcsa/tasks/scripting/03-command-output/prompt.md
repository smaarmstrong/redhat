Write an executable shell script at:

  /usr/local/bin/countusers.sh

The script must capture the output of a command from WITHIN the script
(for example `getent passwd` or `wc -l /etc/passwd`) and print ONLY the
number of user accounts on the system — a single number, nothing else.

The correct count is the number of lines returned by:

  getent passwd

When run, the script's output must equal that number.

Remember to make the script executable.
