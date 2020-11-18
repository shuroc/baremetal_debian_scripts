#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You mustn't run this script as root."
  exit
fi

version=3.0.0

installed_version=$((task --version | cut -d' ' -f3) 2>/dev/null)

if [ "$installed_version" == "" ] || [ "$installed_version" != "$version" ]; then
  # on first installation and
  # on version changes, too
  
  curl -L "https://github.com/go-task/task/releases/download/v$version/task_linux_amd64.deb" -o ./go-task.deb && sudo dpkg -i ./go-task.deb && sudo rm ./go-task.deb    
fi
