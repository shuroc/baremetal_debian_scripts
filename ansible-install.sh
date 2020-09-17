#!/bin/bash

## install prerequisites
apt install -y \
    software-properties-common \
    python3 \
    python3-pip \
    python3-setuptools

## install software
pip3 install ansible
