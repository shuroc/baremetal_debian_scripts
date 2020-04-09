#!/bin/bash

# not sure if go is required for go-task. Probably not, as it comes as a .deb file...
## install go
#golang_version=1.14.2
#curl -L "https://dl.google.com/go/go$golang_version.linux-amd64.tar.gz" -o ./go.tar.gz && sudo tar -C /usr/local -xzf ./go.tar.gz && rm ./go.tar.gz
## add go to path
#echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

# install go-task
gotask_version=2.8.0
curl -L "https://github.com/go-task/task/releases/download/v$gotask_version/task_linux_amd64.deb" -o ./go-task.deb && sudo dpkg -i ./go-task.deb && sudo rm ./go-task.deb