#!/usr/bin/env bash
# Reference solution: -a preserves perms/times and recurses; --delete makes it
# an exact mirror. Trailing slash on the source copies its contents, not the
# directory itself.
rsync -a --delete /srv/source/ /srv/backup/
