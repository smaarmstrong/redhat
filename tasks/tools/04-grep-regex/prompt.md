The file /var/log/access.sample contains about 20 lines of mixed text.
Some lines contain an IPv4 address (four groups of 1-3 digits separated
by dots, e.g. 192.168.0.10); others do not.

Using grep with an extended regular expression (grep -E), write every line
that contains an IPv4 address into /root/ips.txt.

Requirements:
  • Keep the matching lines in their original order.
  • /root/ips.txt must contain the full matching lines (not just the addresses).
