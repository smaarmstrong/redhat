#!/usr/bin/env bash
# Remove any file left by a previous attempt, and make sure the man-db
# keyword index exists so apropos returns results. Building the cache is
# best-effort and can be slow on first run.
rm -f /root/pw-cmds.txt 2>/dev/null
command -v mandb >/dev/null 2>&1 && mandb -q >/dev/null 2>&1
exit 0
