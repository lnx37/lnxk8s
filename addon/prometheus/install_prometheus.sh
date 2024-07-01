#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# wget "https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.13.0.tar.gz"

[ -d kube-prometheus-0.13.0 ] && rm -rf kube-prometheus-0.13.0
tar xzf v0.13.0.tar.gz

cd kube-prometheus-0.13.0

sed -i "s|image: quay.io|image: m.daocloud.io/quay.io|g" manifests/*.yaml
sed -i "s|image: registry.k8s.io|image: m.daocloud.io/registry.k8s.io|g" manifests/*.yaml
sed -i "s|prometheus-config-reloader=quay.io|prometheus-config-reloader=m.daocloud.io/quay.io|g" manifests/*.yaml

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests/

date
