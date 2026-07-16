#!/usr/bin/env bash
cd /opt/rhce/ansible-doc
# ansible-doc ansible.builtin.user shows the "shell" parameter sets the user's login shell.
# ansible-doc ansible.builtin.user | less   # to read it interactively
echo shell > answer.txt
