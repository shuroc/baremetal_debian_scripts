#!/bin/bash

### notes
# currently (2019-08-21) this only works with raspbian stretch, buster does not work.

## install software
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


## user/group modifications
# add current user to docker group
usermod -aG docker $(whoami | awk '{print $1}') # making sure the correct user is added
# if this does not work:
#  curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

read -p "Do you want to reboot now, so the membership gets applied? [y|n] " -n 1 -r
# Note: relog would suffice, but isn't (cleanly) possible from script
if [[ $REPLY =~ ^[Yy]$ ]]
then
    systemctl reboot
fi
echo # start new line
