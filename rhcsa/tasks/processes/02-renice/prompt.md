A background job is running the script `/usr/local/bin/nicejob.sh` at the
default scheduling priority.

It is not urgent, so lower its priority: change the running process's nice
value to **10**.

  • Find the process (for example with `pgrep -f nicejob`).
  • Adjust its nice value while it keeps running — do not kill it.
