#!/usr/bin/env bash
# Reference solution: add a persistent fcontext rule, then apply it.
semanage fcontext -a -t httpd_sys_content_t '/web(/.*)?'
restorecon -Rv /web
