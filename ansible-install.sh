#!/bin/bash

## install prerequisites
apt install -y \
    software-properties-common

## add repository
add-apt-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 # ansible key

## install software
apt update
apt install -y \
    ansible

