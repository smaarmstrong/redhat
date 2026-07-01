The user `auditor` needs to read a ledger file, but you must NOT change
the file's owner or group and must NOT loosen the ordinary "other"
permissions.

  • The file is /srv/data/ledger.csv (owned by root:root, mode 640).
  • Grant the user `auditor` READ access to the file using an access
    control list (ACL) entry, i.e. `user:auditor:r--`.
  • Do not change the file's owner or group ownership.
  • Do not make the file readable by "other".

The ACL must persist after a reboot (ACLs are stored on the file
system, so a normal `setfacl` is enough).
