#/bin/bash

if [[ $EUID != 0 ]]; then
  <&2 echo "You must run this script as root."
  exit
fi

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
timedatectl set-timezone Europe/Berlin

#####
# hardening
#####

apt install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/bantime  = 10m$/bantime  = 1h/' /etc/fail2ban/jail.local
sed -i 's/findtime  = 10m$/findtime  = 1h/' /etc/fail2ban/jail.local
# jail for ssh is activated by default
service fail2ban restart

#####
# install and configure sudo
#####

echo "Installing sudo."
apt install sudo -y

echo "Adding $(who am i | awk '{print $1}') to sudoers."
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
