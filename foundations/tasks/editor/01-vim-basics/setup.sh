#!/usr/bin/env bash
# Clean slate: a small notes file with one word to fix and a line to add.
# The dir and file are world-writable so the learner needs no sudo —
# this lesson is about the editor, nothing else.
rm -rf /opt/found/notes
mkdir -p /opt/found
install -d -m 0777 /opt/found/notes
cat > /opt/found/notes/journal.txt <<'DATA'
Server maintenance notes
------------------------
The backup job runs at 02:00 every night.
Remember to rotate the logs on Friday.
Disk usage is checked MONTHLY.
DATA
chmod 0666 /opt/found/notes/journal.txt
exit 0
