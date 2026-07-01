#!/usr/bin/env bash
# Ensure the 'operator' account exists and remove any leftover target file
# from a previous attempt so the task starts clean.
id operator >/dev/null 2>&1 || useradd -m -c "Operator" operator
rm -f /home/operator/created-by-me.txt 2>/dev/null
exit 0
