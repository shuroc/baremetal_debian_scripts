#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You mustn't run this script as root."
  exit
fi

# no specific version - if not installed, install it now


## install prerequisites
sudo apt install -y \
    software-properties-common apt-transport-https curl

## add repository
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/vscode stable main"

## install software
sudo apt update
sudo apt install -y \
    code

## create settings dir
mkdir -p ~/.config/Code/User

## create settings file if none exists
if [ ! -f ~/.config/Code/User/settings.json ]; then 
echo '{
  "git.autofetch":true,
  "keyboard.dispatch":"keyCode",
  "workbench.startupEditor":"newUntitledFile",
  "editor.wordWrap":"on"
}' > ~/.config/Code/User/settings.json
fi