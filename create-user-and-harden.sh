#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  <&2 echo "You must run this script as root."
  exit
fi


# install prerequisites
apt install -y sudo wget

# add group if it doesn't exist yet
if [ groups | grep "sshusers" == "" ]; then
  groupadd sshusers
fi
# allow group for ssh access (and restart sshd) if not already set
if [ grep "AllowGroups sshusers" /etc/ssh/sshd_config == "" ]; then
  echo "AllowGroups sshusers" | sudo tee -a /etc/ssh/sshd_config >/dev/null
fi

# create user
username=enforge
useradd --create-home --shell /bin/bash $username
  # --shell: define default shell for user
passwd $username # setting userpassword interactively
usermod -aG sudo $username
usermod -aG sshusers $username

# load ssh-key
runuser -l $username -c "~/.ssh"
runuser -l $username -c "chmod 700 ~/.ssh"
runuser -l $username -c "wget -O ~/.ssh/authorized_keys https://github.com/thetillhoff.keys"
runuser -l $username -c "chmod 600 ~/.ssh/authorized_keys"

# disable ChallengeResponseAuthentication (via ssh)
sed -i "s/^#*ChallengeResponseAuthentication .*$/ChallengeResponseAuthentication no/" /etc/ssh/sshd_config
# disable password login (via ssh)
sed -i "s/^#*PasswordAuthentication .*$/PasswordAuthentication no/" /etc/ssh/sshd_config
# disable UsePAM (via ssh)
sed -i "s/^#*UsePAM .*$/UsePAM no/" /etc/ssh/sshd_config
# disable login with root-account (via ssh)
sed -i "s/^#*PermitRootLogin .*$/PermitRootLogin no/" /etc/ssh/sshd_config
systemctl restart sshd

printf "%s\n" \
  "login is now only possible with cert-based ssh as $username"
