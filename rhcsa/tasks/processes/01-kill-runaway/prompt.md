A background process is pinning a CPU core at 100%. It runs the script
`/usr/local/bin/runaway-hog.sh`.

Find the offending process and kill it.

  • Use a tool such as `top`, `ps`, or `pgrep` to locate the process.
  • When you are done, no process running `runaway-hog` may remain.

(You do not need to delete the script itself — just stop the running process.)
