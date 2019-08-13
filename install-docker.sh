# to run this script you must first allow execution
#   chmod +x ./install.sh
# does the trick


### install software
## docker
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-get add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  # $(lsb_release -cs) returns for example "xenial"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
  # about 390 MB