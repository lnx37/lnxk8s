#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl create -f yml/tigera-operator.yaml
# kubectl create -f yml/custom-resources.yaml

kubectl apply -f yml/calico.yaml

date
