#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ -f /root/.kube/config ] && echo "/root/.kube/config already exists" && echo "override anyway"

[ -d /root/.kube ] && rm -rf /root/.kube

mkdir -p /root/.kube

cp -a artifact/kubernetes/kubectl/kubectl.kubeconfig /root/.kube/config

date
