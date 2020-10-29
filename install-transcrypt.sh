#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You're root. This script isn't meant for that."
  exit
fi

version=2.1.0


installed_version=$(transcrypt version)

if [ "$installed_version" == "" ] || [ "$installed_version" != "$version" ]; then
  # on first installation and
  # on version changes, too

  git clone --single-branch --branch v$version https://github.com/elasticdog/transcrypt.git
  chmod +x transcrypt/transcrypt
  sudo mv transcrypt/transcrypt /usr/local/bin/transcrypt
  rm -drf ./transcrypt
fi
