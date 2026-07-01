#!/usr/bin/env bash
# Reference solution.
renice -n 10 -p "$(pgrep -f nicejob | head -1)"
