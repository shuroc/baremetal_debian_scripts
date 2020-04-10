#/bin/bash

echo "Updating apt-packages."
apt update && apt upgrade -y && apt autoremove && apt clean -y

echo "Installing coreutils and ntp."
apt install coreutils ntp -y
echo "To manually resync time use"
echo "  service ntp restart"
sleep 3

echo "Installing sudo."
apt install sudo -y

echo "Adding $USER to sudoers."
/sbin/usermod -aG sudo $(who am i | awk '{print $1}') # making sure the correct user is added

read -p "Do you want to reboot now, so the membership gets applied? [y|n] " -n 1 -r
echo # to move cursor to next line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Note: Logout would suffice, but won't work (cleanly) from script.
  systemctl reboot
fi
echo # start new line

######
# To run this script properly, run it with bash. On Debian (su root) run 'bash ./initial.sh'.
######
