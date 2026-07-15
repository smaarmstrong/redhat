THE IDEA

  sed is the Stream EDitor: it reads text line by line, applies an
  editing instruction to each line, and prints the result. Its one
  instruction you'll use constantly is SUBSTITUTE:

    sed 's/OLD/NEW/' file

  Read the recipe: s, then three slashes fencing off two fields —
  what to find (OLD, a regular expression, from the last lesson) and
  what to replace it with (NEW). After the last slash go the FLAGS;
  the one that matters today is g ("global": every match on the line,
  not just the first).

  Two safety facts that make sed pleasant instead of scary:

    1. By default sed only PRINTS the edited text — the file on disk
       is untouched. You get a free preview, every time.
    2. Only when you add  -i  ("in place") does it rewrite the file.

  So the workflow is always: run it plain, eyeball the output, then
  re-run with -i.

---

  Here's the file to fix — a config with three problems:

```run
cat /opt/found/conflab/app.conf
```

  We need mode=debug flipped to production, every http:// upgraded to
  https:// (spot the mirrors line — it has TWO), and the loglevel line
  deleted. And the banner mentions "DebugCo" — which we must NOT touch.

---

WHY IT MATTERS

  A huge share of admin work is "change one value in a config file".
  You can always do it in vi — and should, while learning — but sed
  does the same edit in one repeatable line, which is why you see it
  all over documentation, scripts, and this course's later lessons
  (SELinux config, GRUB defaults). This lesson is where that
  incantation stops being magic.

---

FIRST SUBSTITUTION — preview, then apply

  Flip the mode. Preview first — no -i, so this only prints:

```run
sed 's/mode=debug/mode=production/' /opt/found/conflab/app.conf
```

  The output shows the second line changed; the banner and everything
  else ride through untouched. Confirm the FILE is still original:

```run
grep -n 'mode=' /opt/found/conflab/app.conf
```

  Still mode=debug — the preview really was just a preview. (Why did
  the pattern not hit "DebugCo"? Because "mode=debug" as a whole
  doesn't appear there — matching more context than the bare word is
  what keeps decoys safe. Anchoring the whole line, 's/^mode=debug$/…/',
  is even stricter — ^ and $ are the same anchors grep uses.)

  Happy with the preview, apply it for real with -i:

```run
sed -i 's/mode=debug/mode=production/' /opt/found/conflab/app.conf
grep -n 'mode=' /opt/found/conflab/app.conf
```

  Now the file itself says mode=production.

---

THE g FLAG — and picking a different fence

  Next: http:// → https://. Two new things at once. First, the OLD
  text contains slashes, and slashes are our fence — escaping each one
  (http:\/\/) works but reads like a hedge. sed lets you use ANY
  character as the fence; # is the usual choice when slashes are
  involved:  s#http://#https://#

  Second: substitution normally replaces only the FIRST match per
  line, and the mirrors line has two. Preview the difference — without
  g, then with:

```run
sed 's#http://#https://#' /opt/found/conflab/app.conf | grep mirrors
sed 's#http://#https://#g' /opt/found/conflab/app.conf | grep mirrors
```

  First run: only mirror a. got upgraded — the second http:// on the
  line survived. With g, both. That first-match-only default is the
  classic sed bug; when you mean "all of them", say g. Apply it:

```run
sed -i 's#http://#https://#g' /opt/found/conflab/app.conf
grep -c 'http://' /opt/found/conflab/app.conf || echo "none left - good"
```

---

DELETING LINES:  /pattern/d

  Substitution is s; deletion is d, with the target line named by a
  pattern between slashes. Preview deleting the loglevel line:

```run
sed '/^loglevel=/d' /opt/found/conflab/app.conf
```

  Six lines, loglevel gone, banner intact. Apply:

```run
sed -i '/^loglevel=/d' /opt/found/conflab/app.conf
```

  (Extra safety net worth knowing: -i.bak, as in sed -i.bak '…' file,
  keeps the original as file.bak before rewriting. On files you can't
  easily restore, use it.)

---

CHECK IT WORKED

  Read the final file:

```run
cat /opt/found/conflab/app.conf
```

  Six lines: production mode, three https:// values (two on the
  mirrors line), no loglevel, banner untouched — exactly what the
  grader compares against, byte for byte.

---

GOTCHAS

  - Forgetting g. First-match-per-line is the default; "why did only
    one change?" is almost always a missing g.
  - Slashes in the pattern. Don't escape your way through URLs — swap
    the delimiter: s#old#new#g (or s|old|new|g).
  - OLD is a regex: dots, stars and brackets are live. Substituting a
    literal IP or filename? Escape the dots (192\.168\.0\.1).
  - Preview before -i. sed -i rewrites the file with no undo. Plain
    run first, or keep a net with -i.bak.
  - Quote the whole instruction in single quotes, like grep patterns —
    'so the shell can't touch $ or #'.
  - Editing root-owned files (that's most of /etc) needs sudo:
    sudo sed -i '…' /etc/whatever.conf. Unlike `sudo cmd > file`,
    this one is fine as-is — sed itself does the writing, so there's
    no redirection trap.
