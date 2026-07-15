Edit /opt/found/conflab/app.conf IN PLACE so that (the directory is
world-writable — no sudo needed):

  • the line  mode=debug  becomes  mode=production
  • EVERY occurrence of  http://  becomes  https://
    (note: one line contains two of them)
  • the line  loglevel=verbose  is deleted entirely
  • everything else is byte-for-byte unchanged — in particular the
    banner line (careful: it contains the word "Debug")

Use sed — that's the skill being practised — though the grader only
checks the final state of the file.
