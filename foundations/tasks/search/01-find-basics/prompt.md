Work on the directory tree under /opt/found/findlab (world-writable —
no sudo needed):

  • Create /opt/found/findlab/logfiles.txt containing the full paths of
    every *.log file under /opt/found/findlab, sorted, one per line.
  • DELETE every *.tmp file under /opt/found/findlab (there are several,
    in different subdirectories). Nothing else may be deleted.
  • Create the directory /opt/found/findlab/big and COPY every file
    larger than 1 MiB under /opt/found/findlab into it (the originals
    must stay where they are).

Use find to locate the files — the tree is deep enough that doing it by
eye defeats the purpose. The grader checks the end state only.
