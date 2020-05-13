#!/bin/bash

# install go-task
gotask_version=2.8.0
curl -L "https://github.com/go-task/task/releases/download/v$gotask_version/task_linux_amd64.deb" -o ./go-task.deb && sudo dpkg -i ./go-task.deb && sudo rm ./go-task.deb
