#!/bin/bash

if [[ $EUID = 0 ]]; then
  <&2 echo "You're root. This script isn't meant for that."
  exit
fi

version=1.14.3


installed_version=$(go version 2>/dev/null | cut -d' ' -f3 | cut -d'o' -f2)
installcheck=$?
if [ $installcheck -ne 0 ]; then
  # first installation only
  export PATH=$PATH:/usr/local/go/bin
fi

if [ $installcheck -ne 0 -or "$installed_version" != "$version" ]; then
  # on first installation and
  # on version changes, too
  curl -L https://dl.google.com/go/gov$version.linux-amd64.tar.gz -o ./go.tar.gz && sudo tar -C /usr/local -xzf ./go.tar.gz && rm ./go.tar.gz
fi
