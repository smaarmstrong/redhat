#!/usr/bin/env bash
command -v git >/dev/null || dnf -y install git >/dev/null 2>&1 || true
d=/opt/rhce/git
rm -rf "$d"
mkdir -p "$d"
# global identity so commits work non-interactively
git config --global user.email >/dev/null 2>&1 || git config --global user.email "student@example.com"
git config --global user.name  >/dev/null 2>&1 || git config --global user.name  "Student"
git config --global init.defaultBranch main >/dev/null 2>&1 || true
# build a bare "origin" repo with one initial commit to clone from
seed="$d/.seed"
mkdir -p "$seed"
( cd "$seed" && git init -q && echo "# origin repo" > README.md && git add README.md && git commit -qm "init" )
git clone -q --bare "$seed" "$d/origin.git"
rm -rf "$seed"
chown -R "${SUDO_USER:-root}": "$d"
exit 0
