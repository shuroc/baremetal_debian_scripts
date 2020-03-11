#/bin/bash

echo "Updating apt-packages."
apt update && apt upgrade -y && apt autoremove && apt clean -y

echo "Installing coreutils and ntp."
apt install coreutils ntp -y
echo "To manually resync time use\n  service ntp restart"
sleep 3

echo "Installing sudo."
apt install sudo -y

echo "Adding $USER to sudoers."
/sbin/usermod -aG sudo $(who am i | awk '{print $1}') # making sure the correct user is added

read -p "Do you want to reboot now, so the membership gets applied? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Note: Logout would suffice, but won't work (cleanly) from script.
  systemctl reboot
fi
echo # start new line

######
# To run this script properly, run it with bash. On Debian run 'sudo bash ./initial.sh'.
######
