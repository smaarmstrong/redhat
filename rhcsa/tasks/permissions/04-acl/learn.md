THE IDEA

  The classic Unix permission model has only three subjects: the owner, one
  group, and everyone else. But what if you need to grant ONE extra person
  read access without changing the owner, without changing the group, and
  without opening the file to the whole world? The three-slot model can't
  express that. Access Control Lists (ACLs) can — they let you attach extra
  per-user and per-group permission entries to a file.

  Here the file /srv/data/ledger.csv is root:root mode 640 (owner rw, group
  r, other nothing). The user auditor needs read, but you must not touch the
  owner, the group, or the "other" bits. An ACL entry user:auditor:r-- is
  exactly the tool for that.

---

  Note: this ledger is mode 640 and root-owned, so reading its ACL
  with `getfacl`, acting as `auditor`, and changing the ACL all need
  privilege — those are prefixed with `sudo`, a normal user granted
  sudo, exactly the exam setup. (`ls -l` and `stat` need no sudo.)

  Look at the starting state and its ACL:

```run
ls -l /srv/data/ledger.csv
sudo getfacl /srv/data/ledger.csv
```

  getfacl prints the effective ACL. Right now it just mirrors the ordinary
  mode (user::rw-, group::r--, other::---) with no extra entries. Confirm
  auditor is locked out:

```run
sudo -u auditor cat /srv/data/ledger.csv
```

  That should fail — auditor isn't the owner, isn't in root's group, and
  "other" has no read.

---

WHY IT MATTERS

  Real permission requirements often don't fit the three-slot model, and
  ACLs are the RHCSA-sanctioned escape hatch. The exam tests them precisely
  in this shape: "give this one user access WITHOUT changing ownership or
  loosening other" — which is impossible with chmod/chown alone.

---

HOW TO DO IT

  setfacl -m ("modify") adds or updates an entry. The syntax is
  type:name:perms — here u for user, the username, then r for read:

```run
sudo setfacl -m u:auditor:r /srv/data/ledger.csv
```

  That's it. The file's owner, group, and other bits are untouched; auditor
  simply gains an extra read entry. The ACL is stored on the filesystem
  itself, so it persists across reboots with no further action.

---

CHECK IT WORKED

  Show the ACL again — you'll now see a new line:

```run
sudo getfacl /srv/data/ledger.csv
```

  Look for user:auditor:r-- among the entries. Notice ls now shows a trailing
  + on the mode, the sign that an ACL is present:

```run
ls -l /srv/data/ledger.csv
```

  And the real test — auditor can now read it, while ownership is unchanged
  and "other" still can't:

```run
sudo -u auditor cat /srv/data/ledger.csv
stat -c '%U:%G %A' /srv/data/ledger.csv
```

  You want root:root, the "other" read bit still a dash, and the cat to
  succeed. That combination — auditor read via ACL, owner still root:root,
  other still not readable — is exactly what grade.sh verifies.

---

GOTCHAS

  - -m modifies/adds one entry; -b (or -x) removes ACL entries. The setup
    used setfacl -b to wipe stale ACLs — don't run that after you've added
    yours or you'll undo your work.
  - Watch the "mask". If a file's group-class perms are tight, the ACL mask
    can clip a named-user entry below what you granted. getfacl shows the
    mask line and an "#effective:" note if an entry is being masked down.
    For a plain r-- request on this file it's fine, but know to check.
  - The + on `ls -l` output is your quick flag that ACLs exist — plain
    chmod/chown output won't show it.
  - You could NOT solve this with chmod without breaking a rule: adding
    group read means changing the group's access to serve one person, and
    "other" read opens it to everyone. The ACL is the only clean fit.
