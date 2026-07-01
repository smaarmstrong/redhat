#!/usr/bin/env bash
# Reference solution: -P writes the persistent policy value.
setsebool -P httpd_can_network_connect on
