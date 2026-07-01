Use find to locate every regular file under /etc whose name ends in .conf
and whose size is larger than 5 kilobytes.

Write their full paths, sorted, into /root/bigconf.txt — one path per line.

Notes:
  • "Larger than 5k" means find's -size +5k test.
  • Only regular files (not directories or symlinks).
  • Sort the resulting list of paths.
