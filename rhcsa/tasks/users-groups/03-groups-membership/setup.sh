#!/usr/bin/env bash
# Nothing is pre-created for this task — just clear any leftovers from a
# previous attempt so it starts clean.
userdel -r alice 2>/dev/null
userdel -r bob 2>/dev/null
groupdel engineers 2>/dev/null
exit 0
