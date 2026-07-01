#!/usr/bin/env bash
# Reference solution: add the port label (persistent by nature).
semanage port -a -t http_port_t -p tcp 8888
