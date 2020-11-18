#!/bin/bash

echo "This is untested and probably won't work."

if [[ $EUID -eq 0 ]]; then
  <&2 echo "You mustn't run this script as root."
  exit
fi

ROOK_VERSION="1.4.5"


# TL;DR
# https://rook.io/docs/rook/v1.4/ceph-quickstart.html
git clone --single-branch --branch v$ROOK_VERSION https://github.com/rook/rook.git
kubectl create -f rook/cluster/examples/kubernetes/ceph/common.yaml
kubectl create -f rook/cluster/examples/kubernetes/ceph/operator.yaml

# -> edit cluster.yaml, so that spec.mon.count: 1, spec.mon.allowMultiplePerNode=: true
#kubectl create -f rook/cluster/examples/kubernetes/ceph/cluster.yaml
