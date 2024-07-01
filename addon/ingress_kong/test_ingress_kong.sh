#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl create deployment web --image=nginx
kubectl expose deployment web --port=80 --target-port=80 --type=NodePort

kubectl apply -f yml/test_kong.yml
kubectl get ingress

date
