#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

cd kube-prometheus-0.13.0

kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup

date
