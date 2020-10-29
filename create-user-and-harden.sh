#!/bin/bash

if [[ $EUID != 0 ]]; then
  <&2 echo "You're not root. This script isn't meant for that."
  exit
fi


# install prerequisites
apt install -y sudo wget

# create user
username=enforge
useradd --create-home --shell /bin/bash $username
passwd $username # setting userpassword interactively
  # --shell: define default shell for user
usermod -aG sudo $username

# load ssh-key
mkdir -p /home/$username/.ssh/
wget -O /home/$username/.ssh/authorized_keys https://github.com/tillhoff.keys
chown -R $username:$username /home/$username/.ssh
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized_keys

# disable ssh-login with root-account
sed -i "s/^#PasswordAuthentication yes$/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/^PermitRootLogin yes$/PermitRootLogin no/" /etc/ssh/sshd_config
systemctl restart sshd


# note: login is now only possible with cert-based ssh as $username