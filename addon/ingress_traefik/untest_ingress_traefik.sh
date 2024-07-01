#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl delete deployment web || true
kubectl delete service web || true

kubectl delete -f yml/test_traefik.yml || true
kubectl get ingress || true

date
