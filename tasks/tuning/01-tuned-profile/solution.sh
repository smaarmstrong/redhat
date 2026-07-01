#!/usr/bin/env bash
# Reference solution.
systemctl enable --now tuned
tuned-adm profile powersave
