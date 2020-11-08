#!/bin/bash

if [[ $EUID != 0 ]]; then
  <&2 echo "You're not root. This script isn't meant for that."
  exit
fi

echo -e "deb http://deb.debian.org/debian buster-backports main contrib
deb-src http://deb.debian.org/debian buster-backports main contrib
" | sudo tee /etc/apt/sources.list.d/buster-backports.list

echo -e "Package: libnvpair1linux libuutil1linux libzfs2linux libzpool2linux spl-dkms zfs-dkms zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=buster-backports
Pin-Priority: 990
" | sudo tee /etc/apt/preferences.d/90_zfs

sudo apt update
sudo apt install -y dpkg-dev linux-headers-$(uname -r) linux-image-amd64
sudo apt install -y zfs-dkms zfsutils-linux
