#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl create deployment web --image=nginx
kubectl expose deployment web --port=80 --target-port=80 --type=NodePort

kubectl get ValidatingWebhookConfiguration
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission || true

kubectl apply -f yml/test_ingress.yml
kubectl get ingress

date
