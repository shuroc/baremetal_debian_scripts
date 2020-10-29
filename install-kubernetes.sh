#!/bin/bash

if [ $EUID -eq 0 ]; then
  <&2 echo "You're root. This script isn't meant for that."
  exit
fi

CONTROL_PLANE_ENDPOINT="k8s.alpha-centauri.enforge.de"
POD_NETWORK_CIDR="10.244.0.0/16"


# configuring container runtime
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
echo "Reminder: No swap!"
echo "Reminder: Please make sure you have docker installed!"

sleep 5 # wait, so the user has time to cancel the script

printf '{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}' | sudo tee /etc/docker/daemon.json >/dev/null
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

# Letting iptables see bridged traffic
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic
sudo modprobe br_netfilter
printf "net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.d/k8s.conf >/dev/null
sudo sysctl --system

# Installing kubeadm, kubelet and kubectl
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
printf "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initializing your control-plane node
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node
if [ "$(grep '$CONTROL_PLANE_ENDPOINT' /etc/hosts)" = "" ]; then
  printf "%-20s%s" "127.0.0.1" "$CONTROL_PLANE_ENDPOINT" | sudo tee -a /etc/hosts >/dev/null
fi
sudo kubeadm init --control-plane-endpoint $CONTROL_PLANE_ENDPOINT --pod-network-cidr $POD_NETWORK_CIDR

# Configuring kubectl
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#more-information
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Installing a Pod network add-on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
# https://docs.projectcalico.org/getting-started/kubernetes/quickstart
## quickstart
wget https://docs.projectcalico.org/manifests/tigera-operator.yaml -O calico-tigera-operator.yaml
kubectl apply -f calico-tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml -O calico-custom-resources.yaml
sed -i "s|cidr: .*$|cidr: $POD_NETWORK_CIDR|" calico-custom-resources.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/custom-resources.yaml
curl -O -L https://github.com/projectcalico/calicoctl/releases/download/v3.16.1/calicoctl
chmod +x calicoctl
sudo mv calicoctl /usr/local/bin/

## kubernetes api datastore, 50 nodes or less
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# ## etcd version:
# curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico.yaml
# kubectl apply -f calico.yaml


# Control plane node isolation
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#control-plane-node-isolation
# -> Allow scheduling of pods on the control-plane node, for example for a single-machine Kubernetes cluster (for development)
kubectl taint nodes --all node-role.kubernetes.io/master-


# Add autocompletion and alias to bashrc
printf "source <(kubectl completion bash)\n" | tee -a ~/.bashrc >/dev/null
printf "alias k=kubectl\n" | tee -a ~/.bashrc >/dev/null
printf "source <(kubectl completion bash | sed 's/kubectl/k/g')\n" | tee -a ~/.bashrc >/dev/null
