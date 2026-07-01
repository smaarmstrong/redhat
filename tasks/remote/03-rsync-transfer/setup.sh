#!/usr/bin/env bash
# Establish a clean starting state: a populated /srv/source and no /srv/backup.

# rsync is in the Rocky 9 base; install best-effort just in case.
rpm -q rsync >/dev/null 2>&1 || dnf -y install rsync >/dev/null 2>&1

# Fresh source tree every time so re-runs are deterministic.
rm -rf /srv/source /srv/backup
mkdir -p /srv/source/subdir

echo "first file"   > /srv/source/alpha.txt
echo "second file"  > /srv/source/beta.conf
echo "nested file"  > /srv/source/subdir/gamma.log

# Give the files distinct, non-default permissions so -a is actually required.
chmod 640 /srv/source/alpha.txt
chmod 600 /srv/source/beta.conf
chmod 644 /srv/source/subdir/gamma.log
# Back-date timestamps so a plain cp (which stamps "now") would differ.
touch -d "2020-01-02 03:04:05" /srv/source/alpha.txt /srv/source/beta.conf \
                               /srv/source/subdir/gamma.log

exit 0
