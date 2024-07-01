#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl apply -f yml/recommended.yaml
# kubectl apply -f yml/dashboard_rbac_v2.7.0.yml
# kubectl -n kubernetes-dashboard create token admin-user

helm repo add k8s-dashboard https://kubernetes.github.io/dashboard
helm install my-kubernetes-dashboard k8s-dashboard/kubernetes-dashboard --version 7.0.1 --create-namespace --namespace kubernetes-dashboard

kubectl apply -f yml/dashboard_rbac_v7.0.1.yml

kubectl -n kubernetes-dashboard create token admin-user

date
