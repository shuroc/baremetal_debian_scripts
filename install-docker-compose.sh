#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You're root. This script isn't meant for that."
  exit
fi

version=1.27.4


installed_version=$((docker-compose version | grep docker-compose | cut -d' ' -f3 | cut -d',' -f1) 2>/dev/null)
installcheck=$?

if [ "$installcheck" != "0" ] || [ "$installed_version" != "$version" ]; then
  # on first installation and
  # on version changes, too

  sudo curl -L "https://github.com/docker/compose/releases/download/$version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
