# to run this script you must first allow execution
#   chmod +x ./install.sh
# does the trick


### notes
# currently (2019-08-21) this only works with raspbian stretch, buster does not work.


### install software
## apt-utils
apt-get install -y apt-utils
## docker
echo "deb http://download.docker.com/linux/debian stretch stable" >> /etc/apt/sources.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io


### user/group modifications
# add (current) 'pi' user to docker group
usermod -aG docker $USER


# if this does not work:
#  curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh