The file /opt/found/awklab/staff.txt holds one record per line, four
colon-separated fields:  username:department:city:budget

Create three files from it (the directory is world-writable — no sudo
needed):

  • /opt/found/awklab/names.txt        the username of every record,
                                       one per line
  • /opt/found/awklab/locations.txt    for every record, one line of
                                       the form  username city
                                       (separated by a single space)
  • /opt/found/awklab/engineering.txt  the FULL original lines of the
                                       records whose department is
                                       exactly Engineering

Keep the original record order. Build the files with awk and
redirection — the grader checks the resulting files only.
