#!/usr/bin/env bash
# Reference solution.
find /etc -type f -name '*.conf' -size +5k | sort > /root/bigconf.txt
