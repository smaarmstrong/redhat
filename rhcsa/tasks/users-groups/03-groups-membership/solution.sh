#!/usr/bin/env bash
# Reference solution.
groupadd -g 4000 engineers
useradd -G engineers alice
useradd -G engineers bob
