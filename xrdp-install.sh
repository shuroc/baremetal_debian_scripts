#!/bin/bash

# How to run
#   Install debian 10 with no gui at all, but with basic-system-tools package.
#   git clone https://github.com/tillhoff/baremetal-debian-scripts
#   chmod +x xrdp-install.sh && xrdp-install.sh

# run install.sh from Microsoft -> xrdp installer
wget https://raw.githubusercontent.com/microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
sudo ./install.sh
rm install.sh

# install gnome-terminal (supports copy-paste)
sudo apt install gnome-terminal -y --no-install-recommends

# configure i3 (before installing, so it detects the config file)
mkdir -p ~/.config/i3/
echo '
' > ~/.config/i3/config

# install i3
sudo apt install i3 -y

# enable passwordless shutdown etc.
sudo echo "## user is allowed to execute shutdown, halt and reboot" >> /etc/sudoers
sudo echo "$USER ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff" >> /etc/sudoers

# next steps message
echo "Next steps:"
echo "- shutdown"
echo "- in the Powershell of the host, enter (github microsoft linux-vm-tools wiki):"
echo "  Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket"
echo "- start & enjoy"