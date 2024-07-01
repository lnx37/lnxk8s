#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl get svc -n kube-system
kubectl get pod -n kube-system

# kubectl describe svc metrics-server -n kube-system
# kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
# curl -k "https://10.244.1.4:10250/apis/metrics.k8s.io/v1beta1"

kubectl top node
kubectl top pod -A

date
