#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl delete -f yml/recommended.yaml
# # kubectl delete -f yml/dashboard_rbac_v2.7.0.yml
# kubectl -n kubernetes-dashboard delete serviceaccount admin-user
# kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

helm delete my-kubernetes-dashboard --namespace kubernetes-dashboard

# kubectl delete -f yml/dashboard_rbac_v7.0.1.yml
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

date
