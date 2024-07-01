#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl get svc kubernetes-dashboard -n kubernetes-dashboard

# kubectl -n kubernetes-dashboard get svc
kubectl get all -n kubernetes-dashboard

date
