# to run this script you must first allow execution
#   chmod +x ./install.sh
# does the trick


### install software
## docker
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/raspbian/gpg | apt-key add -
add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable"
  # $(lsb_release -cs) returns for example "xenial"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io