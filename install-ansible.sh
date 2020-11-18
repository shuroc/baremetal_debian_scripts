#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  <&2 echo "You must run this script as root."
  exit
fi

# no specific version - if not installed, install it now


apt install software-properties-common

add-apt-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

apt update

apt install ansible
