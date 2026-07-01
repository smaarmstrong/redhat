#!/usr/bin/env bash
# Reference solution.
usermod -s /sbin/nologin webadmin
usermod -aG webteam webadmin
usermod -L webadmin
