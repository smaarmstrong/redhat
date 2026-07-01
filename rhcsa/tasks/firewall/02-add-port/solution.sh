#!/usr/bin/env bash
# Reference solution: permanent rule + reload to apply at runtime.
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
