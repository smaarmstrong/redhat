THE IDEA

  `find` walks a directory tree and prints every file that matches the
  TESTS you give it. Each test narrows the results, and multiple tests
  are ANDed together — a file must pass all of them. The three tests you
  need here:

    -type f        it's a regular file (not a directory, not a symlink)
    -name '*.conf' its name matches this shell glob
    -size +5k      it's larger than 5 kilobytes

  The general shape is: find WHERE TESTS. Everything is a filter applied
  to the tree under WHERE.

---

  We're going to search /etc for regular files ending in .conf that are
  bigger than 5k, and save the sorted paths to /root/bigconf.txt. First,
  a taste of find with just one test:

```run
find /etc -name '*.conf' -type f | head
```

  That's already the .conf files; now we add the size filter.

---

WHY IT MATTERS

  "Find every file that is X" is a constant admin need — big files eating
  a disk, configs matching a name, files owned by a departed user, files
  changed recently. find is the tool, and the exam expects fluency with
  its common tests. It also pairs naturally with pipes to sort or act on
  the results.

---

HOW TO DO IT

  Quote the glob `'*.conf'` so the SHELL doesn't expand it in the current
  directory — you want find to do the matching as it walks the tree. The
  size test `+5k` means strictly greater than 5 kibibytes; the k suffix
  is kilobytes, and the + means "more than". Pipe the results through
  `sort` and redirect into the file:

```run
find /etc -type f -name '*.conf' -size +5k | sort > /root/bigconf.txt
```

  find's output order is filesystem order (effectively random), so the
  `sort` is what makes the list deterministic — and the task asks for
  sorted paths.

---

CHECK IT WORKED

  Look at the result:

```run
cat /root/bigconf.txt
```

  Full paths, alphabetically sorted, one per line. The grader runs the
  identical find piped to sort and compares, so matching the tests and
  sorting gives an identical file.

  Sanity-check one entry is genuinely over 5k if you like:

```run
find /etc -type f -name '*.conf' -size +5k -exec ls -lh {} +
```

---

GOTCHAS

  - Quote `'*.conf'`. Unquoted, the shell may expand it against your
    current directory before find ever sees it, and you get the wrong
    results (or an error).
  - -size +5k is "greater than 5k". Bare `5k` means exactly 5k (rounded),
    and `-5k` means smaller — easy to get backwards. The + is essential.
  - -type f excludes directories and symlinks; the task wants regular
    files only. Leave it off and a directory named something.conf could
    sneak in.
  - Don't forget the sort. find alone passes the file-existence check but
    fails the content comparison because the order won't match.
