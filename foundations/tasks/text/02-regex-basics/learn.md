THE IDEA

  grep so far has matched literal text: the pattern "error" means those
  five characters. A REGULAR EXPRESSION (regex) is a pattern that
  describes the SHAPE of text instead: "two capital letters, a dash,
  four digits". One pattern, and every stock code ever printed matches.

  A regex is built from ordinary characters (which match themselves)
  plus a few special ones:

    .        any ONE character
    ^        the start of the line       (an anchor — matches a place)
    $        the end of the line         (the other anchor)
    [abc]    any one of a, b or c        (a character class)
    [A-Z]    any one uppercase letter    (a range)
    [0-9]    any one digit
    [^0-9]   any one character that is NOT a digit
    *        the previous item, repeated ZERO or more times

  And with grep's -E flag (Extended regex) you also get:

    +        the previous item, ONE or more times
    ?        the previous item, optional (zero or one)
    {4}      the previous item, exactly 4 times
    {1,3}    one to three times
    (ab)+    parentheses group things, so a repeat applies to all of it
    a|b      a or b

  Habit to adopt now: quote every pattern in single quotes ('...') so
  the shell leaves it alone, and just always use grep -E — it accepts
  the friendlier operators and everything from plain grep still works.

---

  The practice file is a small inventory list. Look at it:

```run
cat /opt/found/regexlab/inventory.txt
```

  Notice the traps: a CD-77 code that's too short, a bare price "12"
  with no decimals, comment lines starting with #. Literal-text grep
  can't separate those cleanly. Regex can.

---

WHY IT MATTERS

  "Use grep and regular expressions to analyze text" is a named exam
  objective, and regex leaks into everything else: sed replacements are
  regex, journalctl and firewalld and Ansible all speak it. More
  practically — config and log files are full of near-misses, and
  anchors and classes are how you match exactly the line you mean.

---

BUILD A PATTERN, PIECE BY PIECE

  Target: stock codes like AB-1002 — two capitals, a dash, four digits.
  Start too loose and tighten. First attempt — "a dash somewhere":

```run
grep -E '-' /opt/found/regexlab/inventory.txt
```

  Matches the codes... and "old-stock". Too loose. Say "capital letters
  around it": one uppercase letter is [A-Z], one digit is [0-9]:

```run
grep -E '[A-Z]-[0-9]' /opt/found/regexlab/inventory.txt
```

  Better — but CD-77 still sneaks in, and we asked for one letter and
  one digit, not two and four. Counts are what {n} is for:

```run
grep -E '[A-Z]{2}-[0-9]{4}' /opt/found/regexlab/inventory.txt
```

  Exactly the three real codes. CD-77 is out: after its dash there are
  only two digits, and {4} demands four in a row. Read the pattern
  aloud — "an uppercase letter twice, a dash, a digit four times" —
  regexes are less scary pronounced than squinted at.

---

ANCHORS:  ^ and $

  Without anchors, a pattern matches ANYWHERE in the line. Anchors pin
  it down. ^# means "a # at the very start of the line":

```run
grep '^#' /opt/found/regexlab/inventory.txt
```

  Just the two comment lines — NOT any line with a # somewhere inside.
  Now the other end. A price like 4.50 is "one or more digits, a dot,
  exactly two digits" — and $ pins it to the end of the line:

```run
grep -E '[0-9]+\.[0-9]{2}$' /opt/found/regexlab/inventory.txt
```

  Five lines, each ending in a proper decimal price. Two things to
  study in that pattern:

    +      one-or-more digits before the dot (12.50 and 1.05 both fit)
    \.     a LITERAL dot. Bare . means "any character", so without the
           backslash, "1x05" would match too. Escaping specials with \
           is how you say "no, really, that character".

  The bare "hammer classic 12" line didn't match: no dot, no decimals,
  and $ made that non-negotiable.

---

ONE MORE TOOL:  alternation

  | means "or", and parentheses group. All lines mentioning either
  metal:

```run
grep -E 'copper|angle' /opt/found/regexlab/inventory.txt
```

  Grouping matters with anchors: '^(#|note)' means "starts with # or
  note", while '^#|note' means "starts with #, OR has note anywhere".

---

CHECK IT WORKED

  The graded task wants codes.txt, comments.txt and prices.txt built
  from exactly the three patterns you just developed, saved with `>`
  redirection. For instance:

```run
grep -E '[A-Z]{2}-[0-9]{4}' /opt/found/regexlab/inventory.txt > /opt/found/regexlab/codes.txt
cat /opt/found/regexlab/codes.txt
```

  Three lines, no CD-77 — which is precisely what the grader checks.

---

GOTCHAS

  - Quote the pattern. Unquoted, the shell eats * ? ( ) | before grep
    ever sees them, with baffling results. Single quotes, every time.
  - . matches ANY character. grep '192.168.0.1' happily matches
    192x168y0z1. Escape literal dots: 192\.168\.0\.1.
  - Regex * is NOT the shell wildcard. In the shell, *.txt means "files
    ending .txt"; in regex, the same idea is written .*\.txt — * on its
    own just repeats the previous item.
  - Plain grep (no -E) treats + ? { } | ( ) as LITERAL characters
    unless backslashed. If a quantifier "isn't working", you probably
    forgot -E. (You may also see grep -P — Perl regex, with even more
    power — but -E is what the exam material assumes.)
  - Anchors cost nothing and prevent surprises: matching a whole line
    exactly is '^text$' (grep -x does the same).
