#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl get pods --namespace=ingress-nginx

kubectl get services -A |grep "ingress"

kubectl get ingress
kubectl get ValidatingWebhookConfiguration

date
