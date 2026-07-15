THE IDEA

  Every account's password has an aging policy: how long the password may
  be used before it must change, how soon it may be changed again, and how
  many days ahead the user gets warned. These live in /etc/shadow, one
  colon-separated field each:

    field 4  minimum age  (days before the password CAN be changed again)
    field 5  maximum age  (days before the password MUST be changed)
    field 6  warning      (days of "your password expires soon" warning)

  You could edit those numbers by hand, but the friendly front end is
  chage ("change age"). It writes the same fields for you.

---

  Note: reading (and setting) another user's password aging touches
  /etc/shadow, which needs privilege, so these commands are prefixed
  with `sudo` — a normal user who's been granted sudo, exactly the
  exam setup.

  The user appuser already exists with loose defaults (max 99999, min 0,
  warn 14). See its current policy:

```run
sudo chage -l appuser
```

  Note "Maximum number of days" is huge and the minimum is 0 — effectively
  no policy. We're going to tighten it.

---

WHY IT MATTERS

  Forcing passwords to rotate (max age) and giving people warning before
  they expire (warn) is standard hardening, and "set password aging on this
  account" is a stock exam item. Because the values land in /etc/shadow,
  they survive a reboot automatically — no service to enable, no file to
  regenerate.

---

HOW TO DO IT

  chage takes one flag per policy value:

    -M 60   maximum age 60 days
    -m 1    minimum age 1 day
    -W 7    warning 7 days

  Set all three at once:

```run
sudo chage -M 60 -m 1 -W 7 appuser
```

  Watch the case: -M (capital) is MAX, -m (lowercase) is MIN. They are easy
  to swap and the grader checks both.

---

CHECK IT WORKED

  The human-readable view:

```run
sudo chage -l appuser
```

  You should read Maximum 60, Minimum 1, warning 7. If you'd rather see the
  raw fields the grader actually reads, pull them straight from shadow —
  fields 4, 5, 6 are min, max, warn:

```run
sudo getent shadow appuser | cut -d: -f4,5,6
```

  That prints 1:60:7 — min, max, warn — exactly the target.

---

GOTCHAS

  - Case sensitivity: -M is maximum, -m is minimum. Getting these backwards
    is the classic mistake here.
  - chage -l (lowercase L) LISTS the policy; the setting flags are -M -m -W
    -E -I. Don't confuse listing with setting.
  - Don't reach for -d or -E unless asked: -d sets the "last changed" date
    and -E sets an absolute account expiry date — different fields from the
    aging policy this task wants.
  - This only changes aging, not the password itself. The account keeps its
    existing password; you're just adjusting the rules around it.
