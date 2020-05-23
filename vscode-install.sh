#!/bin/bash

## install prerequisites
apt install -y \
    software-properties-common apt-transport-https curl

## add repository
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

## install software
apt update
apt install -y \
    code
