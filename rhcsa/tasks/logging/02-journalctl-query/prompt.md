The system journal contains messages logged under the syslog tag
`rhcsa-drill`. Some of them report the error code `4711`.

Using `journalctl`, collect every message from the `rhcsa-drill` tag that
contains the string `4711`, and write those lines to `/root/drill.txt`.

  • `/root/drill.txt` should contain exactly the matching journal lines,
    one per line (the full journal output lines, as `journalctl` prints them).
  • Filter by the `rhcsa-drill` tag; do not include unrelated messages.
