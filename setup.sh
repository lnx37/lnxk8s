#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl apply -f conf/kubelet_tls_bootstrapping.yml

kubectl apply -f conf/kube_apiserver_to_kubelet.yml

date
