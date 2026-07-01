#!/usr/bin/env bash
# Reference solution: permanent rule + reload to apply at runtime.
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
