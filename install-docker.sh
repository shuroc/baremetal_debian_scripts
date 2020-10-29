#!/bin/bash

if [[ $EUID != 0 ]]; then
  <&2 echo "You're not root. This script isn't meant for that."
  exit
fi

# no specific version - if not installed, install it now


installed_version=$(docker version --format '{{.Server.Version}}')
installcheck=$?

apt install -y \
  apt-utils \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install docker-ce docker-ce-cli containerd.io -y

if [ $installcheck -ne 0 ]; then
  # first installation only

  ## user/group modifications
  # add current user to docker group
  usermod -aG docker $(whoami) # making sure the correct user is added

  read -p "Do you want to reboot now, so the membership gets applied? [y|n] " -n 1 -r
  # Note: relog would suffice, but isn't (cleanly) possible from script
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
      systemctl reboot
  fi
  echo # start new line
fi
