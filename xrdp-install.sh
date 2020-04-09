#!/bin/bash

# run install.sh from Microsoft -> xrdp installer
wget https://raw.githubusercontent.com/microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
chmod +x install.sh
sudo install.sh
rm install.sh

# install gnome-terminal (supports copy-paste)
sudo apt install gnome-terminal -y --no-install-recommends

# configure i3 (before installing, so it detects the config file)
echo '
' > ~/.config/i3/config

# install i3
sudo apt install i3 -y

# enable passwordless shutdown etc.
echo "## user is allowed to execute shutdown, halt and reboot" >> /etc/sudoers
echo "$USER ALL=NOPASSWD: /sbin/halt, /sbin/reboot, /sbin/poweroff" >> /etc/sudoers

# next steps message
echo "Next steps:"
echo "- shutdown"
echo "- in the Powershell of the host, enter (github microsoft linux-vm-tools wiki):"
echo "  Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket"
echo "- start & enjoy"