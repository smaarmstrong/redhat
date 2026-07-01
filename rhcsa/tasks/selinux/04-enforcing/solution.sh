#!/usr/bin/env bash
# Reference solution: set runtime enforcing, and persist in the config.
setenforce 1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
