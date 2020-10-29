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

  curl -L https://golang.org/dl/go$version.linux-amd64.tar.gz -o ./go.tar.gz && sudo tar -C /usr/local -xzf ./go.tar.gz && rm ./go.tar.gz
  git clone https://github.com/elasticdog/transcrypt.git
  mv transcrypt/transcrypt /usr/local/bin/transcrypt
  rm -drf ./transcrypt
  chmod +x /usr/local/bin/transcrypt
fi
