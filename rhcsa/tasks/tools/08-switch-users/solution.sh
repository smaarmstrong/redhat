#!/usr/bin/env bash
# Reference solution: become operator, then create the file as operator.
su - operator -c 'touch /home/operator/created-by-me.txt'
