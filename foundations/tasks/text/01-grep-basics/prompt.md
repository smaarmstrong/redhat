Filter the log file /opt/found/loglab/app.log into three files (the
directory is world-writable — no sudo needed):

  • /opt/found/loglab/errors.txt    every line containing "error" in ANY
                                    letter case (ERROR, error, ...)
  • /opt/found/loglab/warnings.txt  every line containing "warning" in
                                    any case
  • /opt/found/loglab/nodebug.txt   every line that does NOT contain
                                    DEBUG

Keep the lines exactly as they appear in the log, in their original
order. Build the files with grep and redirection — the grader checks the
resulting files only.
