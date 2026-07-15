Using the data file /opt/found/shop/orders.txt, create these four files
(the directory is world-writable — no sudo needed):

  • /opt/found/shop/sorted.txt   the lines of orders.txt in sorted order
                                 (duplicates kept)
  • /opt/found/shop/unique.txt   each product exactly once, sorted
  • /opt/found/shop/count.txt    a single line: the NUMBER of lines in
                                 orders.txt (just the number)
  • /opt/found/shop/errors.txt   the error message printed by
                                     ls /opt/found/shop/nothing-here
                                 captured into the file with 2>

Build each file with redirection (>) and pipes (|) — don't type the
contents by hand. The grader checks the resulting files only.
