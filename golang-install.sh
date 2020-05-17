#!/bin/bash

curl -L https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz -o ./go.tar.gz && sudo tar -C /usr/local -xzf ./go.tar.gz && rm ./go.tar.gz

sudo sed -i 's|PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"|PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/go/bin"|g' /etc/profile