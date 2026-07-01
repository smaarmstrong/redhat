#!/usr/bin/env bash
# Establish a clean starting state: an unlocked webadmin with /bin/bash
# and no membership in webteam, plus an (empty) webteam group.
userdel -r webadmin 2>/dev/null
groupdel webteam 2>/dev/null

groupadd webteam
useradd -s /bin/bash -c "Web Admin" webadmin
# Give the account a password hash so "locked vs unlocked" is meaningful.
echo 'webadmin:Redhat123' | chpasswd
# Make sure it starts unlocked and not yet in webteam.
usermod -U webadmin 2>/dev/null
exit 0
