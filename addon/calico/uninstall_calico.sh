#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl delete -f yml/tigera-operator.yaml
# kubectl delete -f yml/custom-resources.yaml

kubectl delete -f yml/calico.yaml

date
