#/bin/bash

#####
# updating & basic tooling
#####

echo "Updating apt-packages."
apt update && apt upgrade -y && apt autoremove && apt clean -y

echo "Installing coreutils and ntp."
apt install coreutils ntp -y
echo "To manually resync time use"
echo "  service ntp restart"
sleep 3

#####
# hardening
#####

apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/bantime  = 10m$/bantime  = 1h/' /etc/fail2ban/jail.local
sudo sed -i 's/findtime  = 10m$/findtime  = 1h/' /etc/fail2ban/jail.local
# jail for ssh is activated by default
sudo service fail2ban restart

#####
# install and configure sudo
#####

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
