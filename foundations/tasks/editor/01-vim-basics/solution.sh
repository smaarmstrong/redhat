#!/usr/bin/env bash
# Reference solution. The intended path is interactive:
#   vi /opt/found/notes/journal.txt
#     /MONTHLY  Enter          find the word
#     cw weekly Esc            change it
#     G o Reviewed and approved.  Esc     new last line
#     :wq                      save and quit
# The equivalent non-interactive edit (what this script does):
sed -i 's/MONTHLY/weekly/' /opt/found/notes/journal.txt
grep -qx 'Reviewed and approved.' /opt/found/notes/journal.txt \
  || echo 'Reviewed and approved.' >> /opt/found/notes/journal.txt
exit 0
