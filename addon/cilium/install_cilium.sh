#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

which helm >/dev/null 2>&1 || (echo "helm not found" && exit 0)

helm repo add cilium https://helm.cilium.io/ || true
helm install my-cilium cilium/cilium --version 1.15.1

date
