#!/usr/bin/env bash
# Reference solution: drop cockpit from the permanent config, then reload.
firewall-cmd --permanent --remove-service=cockpit
firewall-cmd --reload
