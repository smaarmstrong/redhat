Filter /opt/found/regexlab/inventory.txt into three files using grep
with regular expressions (the directory is world-writable — no sudo
needed):

  • /opt/found/regexlab/codes.txt     lines containing a stock code:
                                      exactly TWO uppercase letters, a
                                      dash, then exactly FOUR digits
                                      (like AB-1002 — but not CD-77)
  • /opt/found/regexlab/comments.txt  lines that START with #
  • /opt/found/regexlab/prices.txt    lines that END with a price:
                                      digits, a literal dot, then
                                      exactly two digits (like 4.50 —
                                      but not a bare 12)

Keep matching lines whole and in their original order. The grader
checks the resulting files only.
