#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You're root. This script isn't meant for that."
  exit
fi

version=1.15.3


installed_version=$(go version | cut -d' ' -f3 | cut -d'o' -f2)

if [ "$installed_version" == "" ]; then
  # first installation only

  echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
  source ~/.profile
fi

if [ "$installed_version" == "" ] || [ "$installed_version" != "$version" ]; then
  # on first installation and
  # on version changes, too

  curl -L https://golang.org/dl/go$version.linux-amd64.tar.gz -o ./go.tar.gz && sudo tar -C /usr/local -xzf ./go.tar.gz && rm ./go.tar.gz
fi
