#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBERNETES_VERSION}"

mkdir -p pkg
mkdir -p artifact/kubernetes/kube-apiserver
mkdir -p artifact/kubernetes/kube-controller-manager
mkdir -p artifact/kubernetes/kube-proxy
mkdir -p artifact/kubernetes/kube-scheduler
mkdir -p artifact/kubernetes/kubectl
mkdir -p artifact/kubernetes/kubelet

cd pkg

# wget -c "https://dl.k8s.io/v1.30.1/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.30.1/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.30.1/kubernetes-server-linux-amd64.tar.gz

[ -d kubernetes ] && rm -rf kubernetes
tar xzf "kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz"

chown -R root:root kubernetes

chmod +x kubernetes/server/bin/kube-apiserver
chmod +x kubernetes/server/bin/kube-controller-manager
chmod +x kubernetes/server/bin/kube-proxy
chmod +x kubernetes/server/bin/kube-scheduler
chmod +x kubernetes/server/bin/kubectl
chmod +x kubernetes/server/bin/kubelet

cp -a kubernetes/server/bin/kube-apiserver          ../artifact/kubernetes/kube-apiserver/kube-apiserver
cp -a kubernetes/server/bin/kube-controller-manager ../artifact/kubernetes/kube-controller-manager/kube-controller-manager
cp -a kubernetes/server/bin/kube-proxy              ../artifact/kubernetes/kube-proxy/kube-proxy
cp -a kubernetes/server/bin/kube-scheduler          ../artifact/kubernetes/kube-scheduler/kube-scheduler
cp -a kubernetes/server/bin/kubectl                 ../artifact/kubernetes/kubectl/kubectl
cp -a kubernetes/server/bin/kubelet                 ../artifact/kubernetes/kubelet/kubelet

cp -a kubernetes/server/bin/kubectl                 /usr/local/bin/kubectl

date
