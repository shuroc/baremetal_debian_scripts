# baremetal-debian-scripts

## what this is about

This contains my most used commands on new debian systems, so why not make it foolproof and create scripts for it?

## how to use

Install your Debian system with 'basic-system-tools'-package selected.
```
$ su root
$ apt install git -y
$ exit
$ git clone https://github.com/tillhoff/baremetal-debian-scripts
$ cd baremetal-debian-scripts
$ chmod +x *.sh
$ su root
$ ./initial.sh
# reboot
$ cd baremetal-debian-scripts
$ ./xrdp-install.sh
$ sudo ./docker-install.sh
# reboot
```
