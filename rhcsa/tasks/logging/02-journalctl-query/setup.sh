#!/usr/bin/env bash
# Establish a clean starting state: seed the journal with tagged messages,
# some containing the target code 4711 and some not (as noise).

# Remove any answer file left over from a previous attempt.
rm -f /root/drill.txt 2>/dev/null

# Emit uniquely-tagged messages. The 4711 lines are the targets;
# the others are decoys under the same tag.
logger -t rhcsa-drill "disk failure imminent code=4711"
logger -t rhcsa-drill "routine health check code=1000"
logger -t rhcsa-drill "sector remap warning code=4711"
logger -t rhcsa-drill "temperature nominal code=2000"
logger -t rhcsa-drill "SMART self-test failed code=4711"

# Give journald a moment to persist them.
sleep 1

exit 0
