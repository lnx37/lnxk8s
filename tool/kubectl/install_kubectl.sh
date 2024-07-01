#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ -f /usr/local/bin/kubectl ] && echo "/usr/local/bin/kubectl already exists" && exit 0

# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.28.md
# wget -c "https://dl.k8s.io/v1.28.10/kubernetes-client-linux-amd64.tar.gz" -O kubernetes-client-linux-amd64.tar.gz
#
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# wget -c "https://dl.k8s.io/release/v1.28.10/bin/linux/amd64/kubectl" -O kubectl
wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.28.10/kubectl" -O kubectl

chown -R root:root kubectl
chmod +x kubectl

cp -a kubectl /usr/local/bin/

kubectl version

date
